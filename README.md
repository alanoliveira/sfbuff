# SFBUFF

SFBuff is a statistics website for SF6.  
It gathers match information from the official website, then provides a variety  
of information for players to track their own performance.

## Environment variables

| variable                                       | description                                                          |
| ---------------------------------------------- | -------------------------------------------------------------------- |
| `SECRET_KEY_BASE`                              | Base secret for all MessageVerifiers in Rails                        |
| `BUCKLER_USER_AGENT`                           | HTTP header `User-Agent` used to make requests to the official site¹ |
| `BUCKLER_EMAIL`                                | Email used to access the official site                               |
| `BUCKLER_PASSWORD`                             | Password used to access the official site                            |
| `DATABASE_URL`                                 | Postgres database url                                                |

¹ The official site is quite restrictive about it. Be sure to use something valid.

## Running with Docker

- Set the environment variables

      export SECRET_KEY_BASE=$(openssl rand -hex 64)
      export BUCKLER_USER_AGENT=Mozilla/5.0...
      export BUCKLER_EMAIL=player@domain...
      export BUCKLER_PASSWORD=623P
    
- Run

      docker-compose up

- Application should be accessible at:

      http://localhost:3000

## Build and running locally

### Prerequisites

- Ruby 3.3.6
- Bundle 2.5.17
- Postgresql 16.2
- Chrome (used as a fallback for login if the attempt using http fails)

### Building

- Install the dependencies

      bundle install
  
- Set the environment variables

      export RAILS_ENV=production
      export SECRET_KEY_BASE=$(openssl rand -hex 64)
      export BUCKLER_USER_AGENT=Mozilla/5.0...
      export BUCKLER_EMAIL=player@domain...
      export BUCKLER_PASSWORD=623P
      export DATABASE_URL=postgres://...

- Prepare the application

      SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
      ./bin/rails db:prepare

### Running

- Start the server

      bin/rails server -p 3000
  
- Application should be accessible at:
  
      http://localhost:3000
