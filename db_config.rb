#!/usr/bin/env ruby
require 'sinatra'
require 'mysql2'
require 'yaml'

get '/' do

config_file = File.join(File.dirname(__FILE__), 'config/database.yml')
credentials = YAML.load(File.read(config_file))
#should convert credentials to symbols

begin
  con = Mysql2::Client.new(:host => credentials['db_host'],
                           :username => credentials['db_username'],
                           :password => credentials['db_password'],
                           :database => credentials['db_name']
)
  rs = con.query("SELECT * FROM bofhwits_posts")
derp = []
rs.each do |row|
    derp <<  "requestor: #{row['requestor']} time: #{row['ts']} username: #{row['user']} post: #{row['post']}"
  end

rescue Mysql2::Error => e
  puts e.errno
  puts e.error

ensure
  con.close if con
end

@bad = derp
  erb :index
end
