# SFBUFF

SFBUFF is a statistics website for SF6.  
It gathers match information from the official website, then provides a variety  
of information for players to track their own performance.

## Development

### Prerequisites

- Ruby 3.4.7
- Bundler 2.7.1
- Postgresql 16.2
- Chromium (used as a fallback for login if the attempt using http fails)
- Yarn 1.22.22 (if you want to use js/css assets locally)

### Environment variables

| variable                                       | description                                                          |
| ---------------------------------------------- | -------------------------------------------------------------------- |
| `SFBUFF_DEFAULT_USER_AGENT`                    | HTTP header `User-Agent` used to make requests to the official site¹ |
| `SFBUFF_BUCKLER_EMAIL`                         | Email used to access the official site                               |
| `SFBUFF_BUCKLER_PASSWORD`                      | Password used to access the official site                            |
| `SFBUFF_USE_LOCAL_ASSETS`                      | Set it if you want to and use local js/css lib dependencies²         |
| `DATABASE_URL`                                 | Postgres database url                                                |

¹ The official site is quite restrictive about it. Be sure to use something valid.
² Otherwise it will use jsdlivr cdn

### Setting up

Run the setup script:

```sh
bin/setup --skip-server
```

Initialize buckler credentials ([more details](#Regarding official site API login)):

```sh
bin/thor buckler_api:reload_credentials --now
```

Start the server with:

```sh
bin/dev
```

The application should be accessible at http://localhost:3000

### Running Tests

To run only unit tests:

```
bin/rspec
```

To run all test suite:

```
bin/ci
```

## Running with Docker

Set the environment variables:

```
export SECRET_KEY_BASE=$(openssl rand -hex 64)
export SFBUFF_DEFAULT_USER_AGENT=Mozilla/5.0...
export SFBUFF_BUCKLER_EMAIL=player@domain...
export SFBUFF_BUCKLER_PASSWORD=623P
```

Run:

```sh
docker-compose up
```

Application should be accessible at http://localhost:3000

## Regarding official site API login

The official site has no actual public API (SFBUFF is getting data from the nextjs endpoints).  
Therefore, authentication is not straightforward.  
Currently there is two workarounds implementations for it (tried in the respective order):

1. Using an HTTP client
  - It depends on the good will of the reverse proxy (sometimes it identifies SFBUFF as a bot)
  - The process involves some posts/redirections so the implementation is messy
2. Using Selenium with Chromium driver
  - Chromium consumes A LOT of ram (which can be impracticable depending on the server)

As an last alternative you must set the authentication cookies manually using:

```
bin/thor buckler_api:set_auth_cookie AUTH_COOKIE
```
