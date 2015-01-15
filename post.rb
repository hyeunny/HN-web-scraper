require 'nokogiri'
require 'open-uri'
require_relative 'comment'

class Post
  attr_reader :comments, :title, :points
  def initialize(url)
    @page = Nokogiri::HTML(open(url))
    @title = extract_post_title
    @url = extract_url
    @points = extract_post_points
    @item_id = extract_item_id
    @comments = []
    map_comments
  end

  def extract_post_title
    title = @page.css('.title').inner_text
  end

  def extract_post_points
    points = @page.css('.subtext span').inner_text
  end

  def extract_url
    ARGV[0]
  end

  def extract_item_id
    url = ARGV[0]
    item_id = url.split('/').last
    item_id_number = item_id.split('=').last
  end

  def extract_comment_bodies
    bodies = @page.search('.comment > font:first-child').map { |font| font.inner_text}
  end

  def extract_comment_authors
    authors = @page.search('.comhead > a:first-child').map { |font| font.inner_text}
  end

  def map_comments
    authors_array = extract_comment_authors
    bodies_array = extract_comment_bodies

    authors_array.each_with_index do |author, index|
      comment = Comment.new(author, bodies_array[index])
      add_comment(comment)
    end
  end

  #pass in comment object
  def add_comment(comment)
    @comments << comment
  end

end