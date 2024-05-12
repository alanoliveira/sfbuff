# Sfbuff

SFBuff is a statistics website for SF6.  
It gathers match information from the official website, then provides a variety  
of information for players to track their own performance.

## Building and running

### General environment variables

| variable             | description                                                          |
| -------------------- | -------------------------------------------------------------------- |
| `BUCKLER_BASE_URL`   | Official site url (`www.str...ter.com`)                              |
| `BUCKLER_EMAIL`      | Email used to access the official site                               |
| `BUCKLER_PASSWORD`   | Password used to access the official site                            |
| `BUCKLER_USER_AGENT` | HTTP header `User-Agent` used to make requests to the official site¹ |
| `BUCKLER_CID_DOMAIN` | Domain used to set cookies necessary to login (`cid.ca...m.com`)     |
| `REPO_URL`           | Url used in the github link on the frontend (optional)               |
| `SENTRY_DSN`         | Sentry DSN, used for reporting errors to Sentry (optional)           |

1. The official site is quite restrictive about it. Be sure to use something valid.

### Build and running local

#### Dependencies

- Ruby 3.3.0
- Node.js 20.9.0
- Yarn 1.22.21
- Postgresql 16.2
- Memcached (used to store jobs results)
- Chromium (used to perform login on the official website)

### Environment variables

| variable             | description                                                          |
| -------------------- | -------------------------------------------------------------------- |
| `DATABASE_URL`       | Postgres database url                                                |
| `MEMCACHED_HOST`     | Memcached server host                                                |
| `MEMCACHED_USERNAME` | Memcached server user                                                |
| `MEMCACHED_PASSWORD` | Memcached server password                                            |

#### Building

After prepare the dependencies and set the environment variables run

```bash
export RAILS_ENV=production
./bin/setup
./bin/rails assets:precompile
```

#### Running

Start the web server
```bash
./bin/rails server
```

Start the job worker
```bash
./bin/bundle exec rake solid_queue:start
```

### Build and run using Docker

After set the environment variables run

```bash
docker compose up
```
