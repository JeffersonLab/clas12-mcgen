#!/usr/bin/env ruby
# gets the tag with the highest semver number
# - "highest" is preferred over "latest", because of backports to old tags may
#   cause them to be "later" than "higher" tags

if ARGV.empty?
  $stderr.puts "USAGE: #{$0} [repo owner]/[repo name]"
  exit 2
end
repo = ARGV[0]

api_args = [
  '--silent',
  '-L',
  '-H "Accept: application/vnd.github+json"',
  '-H "X-GitHub-Api-Version: 2022-11-28"',
  "https://api.github.com/repos/#{repo}/tags",
]
tag_list_unsorted = `curl #{api_args.join ' '} | jq -r '.[].name'`
unless $?.success?
  $stderr.puts "ERROR: failed to get highest tag from repository '#{repo}'"
  exit 1
end

tag_list = tag_list_unsorted.split.map{ |tag|
  begin
    Gem::Version.new tag.gsub(/^v/,'')
  rescue
    nil
  end
}.compact.sort.reverse.map &:to_s

if tag_list.empty?
  $stderr.puts "ERROR: no semver tags found"
  exit 1
end

puts tag_list.first
