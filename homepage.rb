if production?
  ENV['GEM_PATH'] = "#{ENV['HOME']}/gems:/usr/lib/ruby/gems/1.8"
  ENV['GEM_HOME'] = "#{ENV['HOME']}/gems"
  require 'rubygems' || Gem.clear_paths
end

require 'sinatra'

get '/' do
  erb :index
end

