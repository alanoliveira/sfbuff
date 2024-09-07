# SFBUFF

SFBuff is a statistics website for SF6.  
It gathers match information from the official website, then provides a variety  
of information for players to track their own performance.

## Configuration

The following environment variables must be set before run the application:

| variable                                       | description                                                          |
| ---------------------------------------------- | -------------------------------------------------------------------- |
| `BUCKLER_USER_AGENT`                           | HTTP header `User-Agent` used to make requests to the official site¹ |
| `BUCKLER_EMAIL`                                | Email used to access the official site                               |
| `BUCKLER_PASSWORD`                             | Password used to access the official site                            |
| `DATABASE_URL`                                 | Postgres database url                                                |
| `REDIS_URL`                                    | Redis server host                                                    |

¹ The official site is quite restrictive about it. Be sure to use something valid.

## Running with Docker

- Set the environment variables

      export BUCKLER_USER_AGENT = Mozilla/5.0...
      export BUCKLER_EMAIL = player@domain...
      export BUCKLER_PASSWORD = 623P
    
- Run

      docker-compose up -e

- Application should be accessible at:

      http://localhost:3000

## Build and running locally

### Prerequisites

- Ruby 3.3.4
- Bundle 2.5.3
- Node.js 20.9.0
- Yarn 1.22.21
- Postgresql 16.2
- Redis
- Chromium (used to perform login on the official website)

### Building

- Install the dependencies

      bundle install
      yarn install
  
- Set the environment variables

      export RAILS_ENV = production
      export BUCKLER_USER_AGENT = Mozilla/5.0...
      export BUCKLER_EMAIL = player@domain...
      export BUCKLER_PASSWORD = 623P
      export DATABASE_URL = postgres://...
      export REDIS_URL = redis://...

- Prepare the application

      SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
      ./bin/rails db:prepare
      ./bin/rails sfbuff:prepare

### Running

- Start the server

      bin/rails server -p 3000
  
- Application should be accessible at:
  
      http://localhost:3000
