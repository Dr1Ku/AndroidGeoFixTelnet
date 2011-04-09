#!/usr/bin/env ruby

# Import telnet
require 'net/telnet'

# Sensible program defaults, feel free to modify
DEFAULT_CYCLE_TIME = 15 # seconds until the next GPS fix is issued
DEFAULT_LNG_LAT_REGEX = /\d+\.?\d* \d+\.?\d*/ # RegExp for the (lng lat) pairs within the input text fi;e
DEFAULT_EMULATOR_PORT = 5554 # Android Emulator port
DEFAULT_EMULATOR_IP = "127.0.0.1" # Android Emulator IP

# Try to get first argument
if ARGV.length == 0
	puts "At least one parameter (input file) required, e.g. ruby android_geo_fix_telnet.rb 'latlng.txt' !"
	puts "Please try again."
	exit -1
end

# Assign default value, see below
cycle_time = DEFAULT_CYCLE_TIME

# Try to parse cycle time out of command line as well
begin
	cycle_time = Integer(ARGV[1]) if ARGV[1].to_i && ARGV.length == 2
rescue
  puts "WARNING: Error parsing '#{ARGV[1]}', using default cycle time value of #{DEFAULT_CYCLE_TIME} seconds instead !"
end

# Initialize lng_lats container
lng_lats = []

# Try to parse input file
begin
	if File::exists?(ARGV[0]) && File.readable?(ARGV[0])
		# Read lines
		arr = IO.readlines(ARGV[0])
		
		# Make sure that the given lines are in the specified format
		arr.each do |lng_lat_pair|
			unless lng_lat_pair =~ DEFAULT_LNG_LAT_REGEX
				puts "ERROR: Please use the format 'LONGITUDE LATITUDE' (!) e.g. '8.251 53.519' within the text file !"
				puts "Error occured while parsing '#{lng_lat_pair}' !"
				exit -3
			end
		end
	else
	  puts "ERROR: File '#{ARGV[0]}' either doesn't exist or is not readable !"
		puts "Please try again."
		exit -2
	end
rescue
  puts "ERROR: I/O or unexpected, sorry !"
	puts "Please try again."
	raise
	exit -4
end		

# Try to connect to Android Emulator via telnet		
begin
	server = Net::Telnet::new("Host" => DEFAULT_EMULATOR_IP, "Port" => DEFAULT_EMULATOR_PORT)
rescue
	puts "ERROR: No connection could be made to Android Emulator at '#{DEFAULT_EMULATOR_IP}:#{DEFAULT_EMULATOR_PORT}' !"
	puts "Please check that your Android Emulator is running and try again."
	exit -5
end

# Issue a geo fix telnet command every 'cycle_time' seconds
begin
	# Iterate through lng_lat pairs
	lng_lats.each do |lng_lat_pair|
		puts "Fixing on '#{lng_lat_pair}' . . ."
		
		# Issue command
		server.puts("geo fix #{lng_lat_pair}")
		
		# Output response
		server.waitfor(/./) do |data|
			puts "Response: '#{data}'"
		end	
			
		# Sleep for 'cycle_time' seconds
		sleep(cycle_time)
	end

	# Close connection
	server.puts("quit")
	
rescue	
  puts "ERROR: Telnet error or unexpected, sorry !"
	puts "Please try again."
	raise
	exit -6
end	

# Notify user
puts "Done !"