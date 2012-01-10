require 'sinatra'
require 'rest_client'
require 'json'
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'info_source'

#require 'sinatra_more'
#TODO work out the problem with sinatra_more and use content_tag in helpers

if production?
  ENV['GEM_PATH'] = "#{ENV['HOME']}/gems:/usr/lib/ruby/gems/1.8"
  ENV['GEM_HOME'] = "#{ENV['HOME']}/gems"
  require 'rubygems' || Gem.clear_paths
end

configure do
  set :github_user, :agnessa
end

#class Application < Sinatra::Base
#  register SinatraMore::MarkupPlugin
#end

get '/' do
  erb :index
end

INFO_SOURCES = [:github, :linkedin, :wwr, :gild, :bio]

helpers do
  def info_boxes
    r = '<ul id="roundabout">'
      INFO_SOURCES.each do |is|
        r += "<li id=\"#{is}\">"
        r += info_box(is)
        r += '</li>'
      end
    r += '</ul>'
    r
  end
  def info_box(info_source)
    unless INFO_SOURCES.include? info_source
      raise "Invalid info source given"
    end
    name = "#{info_source.to_s.capitalize}Info"
    constant = Object
    constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    is = constant.new
    is.render
  end
end
