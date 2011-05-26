require File.dirname(__FILE__) + '/../spec/support/blueprints'

p 'Creating seeds data for development ...'

2.times { User.make! }
Investor.make!
Startup.make!

p 'Finished creating seeds data for development.'