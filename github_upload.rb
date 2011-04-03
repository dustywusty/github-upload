#!/usr/bin/env ruby

require 'rubygems'
require 'net/github-upload'
require 'optparse'

options = {}

optparse = OptionParser.new do |opts|
	opts.on('-f', '--file FILE', 'file to upload') do |file|
		options[:file] = file
	end
	opts.on('-r', '--repo REPO', 'repo to upload to') do |repo|
		options[:repo] = repo
	end
	opts.on('-d', '--description DESCRIPTION', 'file description') do |description|
		options[:description] = description
	end
	opts.on('-n', '--name FILENAME', 'filename') do |filename|
		options[:filename] = filename
	end
	opts.on('-h', '--help', 'Display this screen') do
		puts opts
		exit
	end
end

begin                                                                                                                                                                                                             
	optparse.parse!
	mandatory = [:file, :repo]
	missing = mandatory.select{ |param| options[param].nil? }
	if not missing.empty?
		puts "missing: #{missing.join(', ')}"
		puts optparse
		exit
	end
	rescue OptionParser::InvalidOption, OptionParser::MissingArgument
		puts $!.to_s
		puts optparse
		exit
end

login = `git config github.user`.chomp
token = `git config github.token`.chomp
repos = options[:repo]
version = `git rev-parse --verify HEAD`.chomp
time = Time.now.to_i

gh = Net::GitHub::Upload.new(
	:login => login,
	:token => token
)

direct_link = gh.upload(
	:repos => repos,
	:file  => options[:file],
	:name => options[:filename],
	:description => "#{options[:description]} #{version}"
)
