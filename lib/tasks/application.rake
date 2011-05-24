# development-only tasks
if Rails.env.development? || Rails.env.test?
  namespace :dev do
    namespace :db do
      desc "recreates the development database from migration, and updates the db schema if necessary"
      task :reset => :environment do
        Rake::Task['db:drop'].invoke
        Rake::Task['db:create'].invoke
        Rake::Task['db:migrate'].invoke
      end
    end
  end
end