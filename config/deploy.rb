
set :application, 'ecmash'
set :repo_url, 'https://github.com/cykod/EcmaSh.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :user, "ecmash"
set :deploy_to, '/var/www/ecmash'
set :scm, :git
set :deploy_via, :remote_cache
set :keep_releases, 5

set :format, :pretty

set :linked_files, %w{.dotenv}

set :rvm_ruby_string, 'ruby-2.0.0-p195' # Change to your ruby version
set :rvm_type, :user# :user if RVM installed in $HOME

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
