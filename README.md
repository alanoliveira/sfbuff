# Sfbuff

SFBuff is a statistics website for SF6.  
It gathers match information from the official website, then provides a variety  
of information for players to track their own performance.

## Building and running

### General environment variables

| variable                                       | description                                                          |
| ---------------------------------------------- | -------------------------------------------------------------------- |
| `BUCKLER_BASE_URL`                             | Official site url (`www.str...ter.com`)                              |
| `BUCKLER_EMAIL`                                | Email used to access the official site                               |
| `BUCKLER_PASSWORD`                             | Password used to access the official site                            |
| `BUCKLER_USER_AGENT`                           | HTTP header `User-Agent` used to make requests to the official site¹ |
| `BUCKLER_CID_DOMAIN`                           | Domain used to set cookies necessary to login (`cid.ca...m.com`)     |
| `DATA_SYNC_THRESHOLD`                          | Minimum interval between players synchronization (in seconds)        |
| `ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY`   | Key used to encrypt AR sensitive data                                |
| `ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT` | Salt used to encrypt AR sensitive data                               |
| `REPO_URL`                                     | Url used in the github link on the frontend (optional)               |
| `SENTRY_DSN`                                   | Sentry DSN, used for reporting errors to Sentry (optional)           |
| `ASYNC_QUEUE_ADAPTER`                          | Set it to use async queue adapter instead solid queue²               |

1. The official site is quite restrictive about it. Be sure to use something valid.
2. Used to keep infrastructure as cheap as possible

### Build and running local

#### Dependencies

- Ruby 3.3.0
- Node.js 20.9.0
- Yarn 1.22.21
- Postgresql 16.2
- Redis
- Chromium (used to perform login on the official website)

### Environment variables

| variable         | description           |
| ---------------- | --------------------- |
| `DATABASE_URL`   | Postgres database url |
| `REDIS_URL`      | Redis server host     |
| `REDIS_USERNAME` | Redis server user     |
| `REDIS_PASSWORD` | Redis server password |

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
./bin/worker
```

### Build and run using Docker

After set the environment variables run

```bash
docker compose up
```
