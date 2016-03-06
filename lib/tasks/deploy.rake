namespace :deploy do
  desc 'Deploy the app to production'
  task :production do
    app = "parking-strasbourg"
    remote = "git@scalingo.com:#{app}.git"

    system "git push #{remote} master"
    system "scalingo run 'rake sitemap:refresh'"
    system "scalingo run 'rake cache:clear'"
  end
end
