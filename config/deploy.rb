require 'capistrano/novelys'

use_stack :rbenv, :logs, :stages, :remote_commands, :production_chain, :whenever, :mongoid

load 'deploy/assets'

set(:application)      {"parkingstrasbourg" }
