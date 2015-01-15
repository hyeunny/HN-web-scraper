We're going to write a simple [Hacker News](https://news.ycombinator.com/) scraper. 

Incase you're not fully sure what web scraping is, check out [this useful resource](https://www.google.ca/search?q=what+is+a+web+scraper).

We're going to build Ruby classes that represent a particular Hacker News comment thread.

### Learning Goals
The main goal is to learn how to translate a pre-existing object model â€” in this case, Hacker News' model â€” using OOP in Ruby.

This assignment will also have us:

* Recalling fundamental/basic HTML and CSS
* Learning about the Nokogiri gem
* Learning about using `ARGV` for Command-Line arguments
* Learning about the `curl` command line tool.
* Learning about the Ruby's `OpenURI` module

### Objectives

#### Save a HTML Page

First, we're going to save a specific HN post as a plain HTML file for us to practice on. As we're developing a scraper we'll be tempted to hammer the HN servers, which will almost certainly get everyone temporarily banned. We'll use the local HTML file to get the scraper working before we create a "live" version.

Note that this implies something about how your class should work: it shouldn't care how it gets the HTML content.

Visit the Hacker News homepage and click through to a specific post. I'd suggest a cool one, like the [Show HN: Velocity.js â€“ Accelerated JavaScript animation (VelocityJS.org)](https://news.ycombinator.com/item?id=7663775) post. You can save the HTML for this page somewhere using the `curl` command.

SSH into your vagrant box, `cd` into your project directory, and run the following command:

    $ curl https://news.ycombinator.com/item?id=7663775 > post.html
    
_NOTE:_ The $ is not to be typed in literally, it denotes the command prompt. 

This will create a `post.html` file which contains the HTML from the URL you entered. You're free to enter another URL.

#### Playing around with Nokogiri

First, make sure the `nokogiri` gem is installed. We'll use this to parse the HTML file. You can test this by running irb/pry and typing

    require 'nokogiri'

If you get an error that means Nokogiri is not installed. Install it by running this command:

    $ gem install nokogiri

You'll want to have the [Nokogiri documentation about parsing an HTML document](http://nokogiri.org/tutorials/parsing_an_html_xml_document.html) available. Try this from irb/pry:

    doc = Nokogiri::HTML(File.open('post.html'))
    
For this to work, make sure you run this ruby code from the same directory as `post.html`.

What does the Nokogiri object itself look like? Don't worry about having to sift through it's innards, but reading [Parsing HTML with Nokogiri](http://ruby.bastardsbook.com/chapters/html-parsing/) from The Bastard's Book of Ruby can give you a feel for how Nokogiri works.

Here's an example method that takes a Nokogiri document of a Hacker News thread as input and returns an array of commentor's usernames:

    def extract_usernames(doc)
      doc.search('.comhead > a:first-child').map do |element|
        element.inner_text
      end
    end

It's likely been a while since you've dealt with [CSS Selectors](http://css.maxdesign.com.au/selectutorial/), which is what the `search` method is using to select elements off the page. If you're feeling uncomfortable about them, feel free to revisit that section in the prep course.

What do these other Nokogiri calls return?

    doc.search('.subtext > span:first-child').map { |span| span.inner_text}
    doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }
    doc.search('.title > a:first-child').map { |link| link.inner_text}
    doc.search('.title > a:first-child').map { |link| link['href']}
    doc.search('.comment > font:first-child').map { |font| font.inner_text}
    
What is the data structure? Can you call ruby methods on the returned data structure?

Make sure you open up the html page in your browser and poke around the source code to see how the page is structured. What do their tags actually look like? How are those tags represented in the Nokogiri searches?

#### Creating Your Object Model

We want two classes: `Post` and `Comment`. A post has many comments and each comment belongs to exactly one post. Let's build the `Post` class so it has the following attributes: `title`, `url`, `points`, and `item_id`, corresponding to the title on Hacker News, the URL the post points to, the number of points the post currently has, and the post's Hacker News item ID, respectively.

Additionally, create two instance methods:

1. `Post#comments` returns all the comments associated with a particular post
2. `Post#add_comment` takes a `Comment` object as its input and adds it to the comment list.

You'll have to design the Comment object yourself. What attributes and methods should it support and why? 

We could go deeper and add, e.g., a User model, but we'll stop with Post and Comment.

#### Loading Hacker News Into Objects

We now need code which does the following:

1. Instantiates a Post object
2. Parses the Hacker News HTML
3. Creates a new Comment object for each comment in the HTML, adding it to the Post object in (1)

Boom... Ship it!

#### Command line + parsing the actual Hacker News

We're going to learn two new things: the basics of parsing command-line arguments and how to fetch HTML for a website using Ruby. We want to end up with a command-line program that works like this:

    $ ruby hn_scraper.rb https://news.ycombinator.com/item?id=5003980
    Post title: XXXXXX
    Number of comments: XXXXX
    ... some other statistics we might be interested in -- your choice ...
    $

First, read [this blog post about command-line arguments in Ruby](http://alvinalexander.com/blog/post/ruby/how-read-command-line-arguments-args-script-program). How can you use `ARGV` to get the URL passed in to your Ruby script?

Second, read about Ruby's [OpenURI](http://www.ruby-doc.org/stdlib-2.0.0/libdoc/open-uri/rdoc/OpenURI.html) module. By requiring 'open-uri' at the top of your Ruby program, you can use open with a URL:

    require 'open-uri'

    html_file = open('http://www.ruby-doc.org/stdlib-2.0.9/libdoc/open-uri/rdoc/OpenURI.html')
    puts html_file.read

This captures the html from that URL as a `StringIO` object, which NokoGiri accepts as an argument to `NokoGiri::HTML`.

Combine these two facts to let the user pass a URL into your program, parse the given Hacker News URL into objects, and print out some useful information for the user.