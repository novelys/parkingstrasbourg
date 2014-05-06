namespace :deploy do
  desc 'Deploy the app to staging'
  task :staging do
    app = "parkings-strasbourg-staging"
    remote = "git@appsdeck.eu:#{app}.git"

    system "git push #{remote} master"
    system "appsdeck --app #{app} run 'rake sitemap:refresh'"
    system "appsdeck --app #{app} run 'rake cache:clear'"
  end
end
