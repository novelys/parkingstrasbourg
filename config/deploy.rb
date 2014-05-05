require 'capistrano/novelys'

use_novelys_and :rails, :mongoid

load 'deploy/assets'

set(:application) {"parkingstrasbourg" }
