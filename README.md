# Angel Nest

## Stack

- ruby 1.9.2
- rails 3.1

## Setup Instructions

- `gem install bundler`
- `bundle install`

## Run Test Suites

- `rake spec` for integration and unit tests
- `rake cucumber` for acceptance tests

## Development Notes

In order to keep DB migration to minimum, migration files are modified during the development. Please run `rake dev:db:reset` to keep your database schema up to date.