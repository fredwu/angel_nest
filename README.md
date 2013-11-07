# Angel Nest [![Build Status](https://secure.travis-ci.org/fredwu/angel_nest.png?branch=master)](http://travis-ci.org/fredwu/angel_nest) [![Dependency Status](https://gemnasium.com/fredwu/angel_nest.png)](https://gemnasium.com/fredwu/angel_nest) [![endorse](http://api.coderwall.com/fredwu/endorsecount.png)](http://coderwall.com/fredwu)

- Hacker News comments: http://news.ycombinator.com/item?id=2891907
- Reddit comments: http://www.reddit.com/r/programming/comments/jkr8r/developer_opensources_200_hr_project_after_client/
- The story behind this: http://fredwu.me/post/9036730472/open-sourcing-a-200-hour-project-the-story-behind-it
- The things I have learnt: http://fredwu.me/post/9703934823/startup-vc-and-the-things-i-learnt-from-open-sourcing

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

## System Info

### Stack

- ruby 1.9
- rails 3.2

### Setup Instructions

- `gem install bundler`
- `bundle install`

### Run Test Suites

- `rake spec` for integration and unit tests

### Development Notes

In order to keep DB migration to minimum, migration files are modified during the development. Please run `rake dev:db:reset` to keep your database schema up to date.

## Setup Guide

In order to run the system (for demo and development purposes), you may follow the following steps:

- clone the repo, obviously
- if you use [RVM](http://beginrescueend.com/), you may rename the `_rvmrc` file to `.rvmrc` and adjust its content accordingly
- copy or rename `config/database.example.yml` to `config/database.yml` and adjust its content accordingly
- `bundle install`
- `rake db:create`
- `rake dev:db:reset`
- `rails s`
- done, fire up your browser and browse to `http://localhost:3000/` :)
- the default login is `test@example.com` and password `password`

## License

Dual licensed under the [MIT](http://www.opensource.org/licenses/mit-license.php) and [GPL](http://www.gnu.org/licenses/gpl.html) licenses.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/fredwu/angel_nest/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

