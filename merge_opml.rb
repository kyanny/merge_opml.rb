#!/usr/bin/env ruby
require 'bundler/setup'
require 'opml'
require 'builder'

def get_feed file
  Opml.new(open(file).read).flatten.select { |opml|
    opml.attributes['xml_url']
  }
end

feeds = []
Dir['*.xml', '*.opml'].each do |file|
  $stderr.puts "Collecting feeds from #{file}..."
  feeds += get_feed(file)
end

builder = Builder::XmlMarkup.new indent: 2
builder.instruct!
builder.opml version: '1.0' do
  builder.body do
    feeds.each do |feed|
      builder.outline({}.tap {|h| feed.attributes.each{|k,v| h[k.camelize(:lower)] = v }})
    end
  end
end
puts builder.target!
