require_relative 'post'


class NoURLError < StandardError
end


begin
  url = ARGV[0]
  raise NoURLError if url.nil?
  post = Post.new(url) 
  
  puts 
  puts "Title: ".colorize(:magenta) + "#{post.title}"
  puts
  puts "Points: ".colorize(:magenta) + "#{post.points}"
  puts
  post.comments.each {|comment| puts puts comment}
  rescue NoURLError
  puts "you didn't put in a url"
end



