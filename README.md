# Angel Nest

## What is Angel Nest?

Angel Nest is the code name of a project initially commissioned by a so called entrepreneur. The system itself and the business are modelled after [AngelList](http://angel.co/). The goal of this project was to become one of the first ones targeted at the Chinese entrepreneurship and investment market.

## Why is it open-sourced now?

After spending 200+ hours developing the system, not a dime has been seen or given. The work itself has given me an incredible amount of stress due to the tight schedule and the ever delaying job contract.

Weeks have gone by without any light of payment coming through, thereby I am releasing the source code, hopefully it will at least benefit some people who might be interested.

## What is the state of the system?

The system, even though was developed under pressure, is in a reasonably good state. It has sufficient unit test coverage (though no view tests or integration tests) and in some parts the UI works better than AngelList. The front-end JavaScript code is a bit hacky and messy however.

## Are you going to develop this further?

Probably no, but if you think this system could be used for something else, and you would like to work on it together, please feel free to drop me a line.

## This system sucks

Well duh. I have my day job as well as my own adventure to worry about on top of this stressful project, so please cut me some slack. ;)

## System

### Stack

- ruby 1.9.2
- rails 3.1

### Setup Instructions

- `gem install bundler`
- `bundle install`

### Run Test Suites

- `rake spec` for integration and unit tests
- `rake cucumber` for acceptance tests

### Development Notes

In order to keep DB migration to minimum, migration files are modified during the development. Please run `rake dev:db:reset` to keep your database schema up to date.