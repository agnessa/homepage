log = File.new('sinatra.log', 'a')
STDOUT.reopen(log)
STDERR.reopen(log)

ENV['GEM_PATH'] = "#{ENV['HOME']}/gems:/usr/lib/ruby/gems/1.8"
ENV['GEM_HOME'] = "#{ENV['HOME']}/gems"

require 'rubygems' || Gem.clear_paths
require 'sinatra'
require 'homepage'

set :environment, :production
disable :run, :reload

run Sinatra::Application
