require 'serverspec'
require 'net/ssh'
require 'json'
require 'ohai'

ohai = Ohai::System.new
ohai.all_plugins

puts '----------------------------------'
puts 'Hello! ' + ohai[:platform]
puts '----------------------------------'

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
#    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']
set_property JSON.parse(File.read("nodes/#{host}.json"))

options = Net::SSH::Config.for(host)
options[:user] = ENV['USER'] || Erc.getlogin
options[:keys] = ENV['KEY']
#options[:passphrase] = ENV['PASSPHRASE'];
options[:password] = 'root' || ENV['LOGIN_PASSWORD']

set :host,        options[:host_name] || host
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C' 

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'
