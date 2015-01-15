require 'colorize'
class Comment
  attr_reader :author, :body 
  def initialize(author, body)
    @author = author.colorize(:magenta)
    @body = body.colorize(:yellow)
  end

  def to_s
    "#{author}\n#{body}"
  end
end