require 'capistrano/novelys'
load 'novelys/rbenv'
load 'novelys/unicorn'
load 'novelys/logs'
load 'novelys/stages'
load 'novelys/remote_commands'
load 'novelys/production_chain'
load 'novelys/rails3'
load 'novelys/mongoid'
load 'novelys/whenever'
load 'deploy/assets'

set(:application) { "parkingstrasbourg" }
