# SFBUFF

SFBUFF is a statistics website for SF6.  
It gathers match information from the official website and provides various insights and statistics for players to track their performance.

## Development

### Prerequisites

- Ruby 3.4.7
- Bundler 2.7.1
- PostgreSQL 16.2
- Chromium (used as a fallback for login if the attempt using HTTP fails)
- Yarn 1.22.22 (if you want to use JS/CSS assets locally)

### Environment variables

| variable                                       | description                                                          |
| ---------------------------------------------- | -------------------------------------------------------------------- |
| `SFBUFF_DEFAULT_USER_AGENT`                    | HTTP header `User-Agent` used to make requests to the official site¹ |
| `SFBUFF_BUCKLER_EMAIL`                         | Email used to access the official site                               |
| `SFBUFF_BUCKLER_PASSWORD`                      | Password used to access the official site                            |
| `SFBUFF_USE_LOCAL_ASSETS`                      | Set this if you want to use local JS/CSS dependencies²               |
| `DATABASE_URL`                                 | Postgres database URL                                                |

¹ The official site is quite restrictive. Be sure to use a valid User-Agent.  
² Otherwise, it will use the jsDelivr CDN.

### Setting up

Run the setup script:

```sh
bin/setup --skip-server
```

Initialize Buckler credentials (more details [here](#regarding-the-official-sites-api-login)):

```sh
bin/thor buckler_api:reload_credentials --now
```

Start the server with:

```sh
bin/dev
```

The application should be accessible at http://localhost:3000.

### Running Tests

To run only unit tests:

```
bin/rspec
```

To run the entire test suite:

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

The application should be accessible at http://localhost:3000.

## Regarding the official site's API login

The official site has no public API (SFBUFF retrieves data from the Next.js endpoints), therefore, 
authentication is not straightforward.  
Currently there are two workaround implementations (tried in the following order):

1. Using an HTTP client
   - It depends on the goodwill of the reverse proxy (sometimes it identifies SFBUFF as a bot).
   - The process involves multiple POSTs/redirections, so the implementation is messy.

2. Using Selenium with the Chromium driver
   - Chromium consumes a lot of RAM (which can be impractical depending on the server).

As a last alternative, you can set the authentication cookies manually using:

```
bin/thor buckler_api:set_auth_cookie AUTH_COOKIE
```
