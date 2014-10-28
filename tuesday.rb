#!/usr/bin/env ruby
#use system to get the process messages for the user
#use `` for quick process messages and need the return as a string
require 'colorize'

class Tuesday
  #kitchen
  #domain
  #app_type
  #path
  #databases
  @@kitchen_path = "/usr/local/bin/kitchen"
  def self.kitchen_path
    @@kitchen_path
  end
  def self.installs
    puts "#{"#"*5}Installation#{"#"*5}"
    #check ruby gem version
    str = ""
    File.open("#{@@menu[:path].strip}/Gemfile").each do |f|
      str += f
    end
    @@menu[:ruby_version] = str[/ruby "....."/,0][6..10] #Will need to fix this in the future for JRuby support
    if @@menu[:ruby_version].nil?
      puts "You have no ruby version declared in your Gemfile. Please update it."
      abort
    else
      #puts "I see you are using ruby #{@@menu[:ruby_version]}"
      #puts "rvm use #{@@menu[:ruby_version]}"
      #system "rvm use #{@@menu[:ruby_version]}"
      #install the gems
      system "bundle install"
    end

    #check if nginx is installed
    if `which nginx` == ""
      puts "You appear to be missing nginx"
      puts "Don't worry I'll install it now"
      system "sudo apt-get install nginx"
    end
    #Now get rid of the bad nginx
    puts "Killing the bad nginx"
    system "rm /etc/nginx/conf.d/defaults"
    system "rm /etc/nginx/sites-available/*"
    system "rm /etc/nginx/sites-enabled/*"
    system "rm /etc/nginx/conf.d/default.conf"

    #Time for Databases
    puts "Time to build up the databases"
    case @@menu[:database]
    when "mongodb"
      if `which mongod` != ""
        puts "You have MongoDB already installed"
      else
        puts "You appear to not have Mongodb installed"
      end
    when "postgressql", "pg", "psql"
      if `which psql` != ""
       puts "You have Postgressql already installed"
     else
       puts "You appear to now have Postgressql installed"
     end
    else
      puts "I don't recognize that database. You will have to install it yourself and make sure your pathing is correct"
    end

    #Time for web servers
    puts "Now to do Web Servers"
    @@menu[:webserver].downcase! unless @@menu[:webserver].nil? #make sure its not nil first
    if @@menu[:webserver] == "puma" || @@menu[:webserver] == "unicorn" || @@menu[:webserver] == "thin" || @@menu[:webserver] == "passanger"
      if `gem list "#{@@menu[:webserver]}"`.include? "("
        puts "#{@@menu[:webserver]} is already installed"
      else
        puts "You don't have #{@@menu[:webserver]}  installed don't worry I got you"
        system "gem install #{@@menu[:webserver]}"
      end
    else
      puts "I'm sorry I don't recognize that web server.....you will have to manually set it up :/ sorry"
    end
  end

  def self.readMenu
    begin
      # Exceptions raised by this code will
      # be caught by the following rescue clause
      @@menu = eval("{#{IO.readlines("Menufile").join.strip}}")
    rescue
      puts "It appears you are missing or have a corrupt Menufile. Please consult http://tuesdayrb.me for support"
      abort
    end
    @@menu[:path] = `pwd`
    @@menu[:domain].downcase!
    @@menu[:webserver].downcase!
    @@menu[:database].downcase!
  end

  def self.configure
    #kill the old version of this server
    #set up the new version
    #store it in kitchen
  end
  def self.restart_servers
    #run this new server
    #system "service nginx restart"
  end

  def self.run
	 puts "Welcome to Ruby-Tuesdays	"
   readMenu
   installs
   configure
   restart_servers
  end
end

$PROGRAM_NAME = 'Tuesday'
#puts $0 # This is an alias for the same thing.

#Setting up the kitchen in localbin
`touch  "#{Tuesday.kitchen_path}"`
`chmod a+x "#{Tuesday.kitchen_path}"`

Tuesday.run
