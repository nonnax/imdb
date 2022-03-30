#!/usr/bin/env ruby
# Id$ nonnax 2022-03-30 14:23:39 +0800
require 'mechanize'

q,=ARGV
# https://www.imdb.com/find?q=dog&s=tt&ttype=ft&ref_=fn_ft
u="https://www.imdb.com/find?q=#{q}&s=tt&ttype=ft&ref_=fn_ft"
agent=Mechanize.new

page=agent.get(u)

links=Hash.new{|h, k| h[k]=[] }

page.links.each do |l|
  next unless l.href && l.href.match?(%r{/title/tt})
  img=l.node.xpath('.//img').first
  links[l.resolved_uri.to_s] << img[:src] unless img.nil?
  links[l.resolved_uri.to_s] << l.text unless l.text.empty?
end

links.each do |r|
  p r.flatten.values_at(-1, 0, 1)
end
