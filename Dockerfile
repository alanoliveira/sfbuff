# syntax = docker/dockerfile:1

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t my-app .
# docker run -d -p 80:80 -p 443:443 --name my-app -e RAILS_MASTER_KEY=<value from config/master.key> my-app

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.1

# build updated openssl (necessary for buckler login)
FROM docker.io/library/debian:bookworm-slim AS openssl
RUN apt-get update -qq && apt-get install -y curl build-essential zlib1g-dev ca-certificates && \
    curl -sL https://www.openssl.org/source/openssl-3.4.0.tar.gz | tar xz -C /tmp/ && \
    cd /tmp/openssl-3.4.0 && \
    ./config --prefix=/usr/local/openssl-3.4.0 --openssldir=/usr/local/openssl-3.4.0 shared zlib && \
    make && make install && \
    cd && rm -rf /tmp/openssl-3.4.0

FROM docker.io/library/ruby:$RUBY_VERSION-slim-bookworm AS base

# Copy compiled openssl
COPY --from=openssl /usr/local/openssl-3.4.0 /usr/local/openssl-3.4.0
RUN apt-get remove -y openssl && \
    ln -s /etc/ssl/certs/ca-certificates.crt /usr/local/openssl-3.4.0/cert.pem && \
    echo "/usr/local/openssl-3.4.0/lib64" > /etc/ld.so.conf.d/openssl-3.4.0.conf && \
    ldconfig
ENV PATH=/usr/local/openssl-3.4.0/bin:$PATH

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client chromium-driver geoip-database && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="docker" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile




# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
