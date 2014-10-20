#!/usr/bin/env ruby
require 'sinatra'
require 'mysql2'
require 'yaml'
require 'cgi'
# to do:
# move mysql connection into its own function
# add an about page
# make variable names useful
#
get '/' do

config_file = File.join(File.dirname(__FILE__), 'config/database.yml')
credentials = YAML.load(File.read(config_file))

begin
  con = Mysql2::Client.new(:host => credentials['db_host'],
                           :username => credentials['db_username'],
                           :password => credentials['db_password'],
                           :database => credentials['db_name']
)
  rs = con.query("SELECT * FROM bofhwits_posts")
@bad = []
rs.each do |row|
  escapeRow = Hash.new
  escapeRow['requestor'] = CGI.escapeHTML(row['requestor'])
  escapeRow['ts'] = row['ts']
  escapeRow['user'] = CGI.escapeHTML(row['user'])
  escapeRow['post'] = CGI.escapeHTML(row['post'])

  @bad << escapeRow
end
@bad.reverse!
rescue Mysql2::Error => e
  puts e.errno
  puts e.error

ensure
  con.close if con
end

  erb :index
end
