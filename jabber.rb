#!/usr/bin/env ruby

require 'bundler/setup'
require 'blather/client'
require 'redis'

REDIS = Redis.new

setup 'developer@highgroove.com', '******', 'talk.google.com'

subscription :request? do |s|
  write_to_stream s.approve!
end

message :chat?, :body => /^Add Link\:/ do |m|
  link = m.body.gsub(/^Add Link:/, '').gsub(/<.*>/, '').strip
  REDIS.rpush 'links', link
end