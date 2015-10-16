require 'open-uri'

module Enumerable
  def pmap(cores = 10, &block)
    [].tap do |result|
      each_slice((count.to_f/cores).ceil).map do |slice|
        Thread.new(result) do |result|
          slice.each do |item|
            result << block.call(item)
          end
        end
      end.map(&:join)
    end
  end

  def dups
    inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys
  end
end


class WikiReader
  attr_reader :wiki_state_colleges, :base_wiki_url

  def self.report_time
    t = Time.now
    yield
    puts Time.now-t
  end

  def self.build
    new.array_of_schools
  end

  def initialize
    @wiki_state_colleges = "https://en.wikipedia.org/wiki/List_of_state_universities_in_the_United_States"
    @base_wiki_url = "https://en.wikipedia.org"
  end

  def array_of_schools
    @array_of_schools ||= get_school_urls.pmap {|url| school_hash(url)}.compact.delete_if {|s| s["title"] == ""}.uniq
  end

  private

  def school_hash school_link
    unless /wiki/.match(school_link).nil?
      page = read_page "#{base_wiki_url}#{school_link}"
      title = page.css(".fn.org").text.gsub("\n",", ")
      trs = page.css(".vcard tr").select {|tr| tr.css("th").any? }
      hash = {"title" => title}
      trs.each do |tr|
        #regex explained: removes first comma in key
        #removes all square brackets and everything between them,
        #removes empty spaces and black space looking characters in the end of lines,
        #removes new lines in the end of lines
        hash[tr.css("th").text.gsub("\n",", ").gsub(/,\s\b|\[(.*?)\]|\W+$/,"").strip] = tr.css("td").text.gsub(/\[(.*?)\]|\W+$/,"").gsub("\n",", ").strip
      end
      puts title
      hash
    end
  end

  def get_school_urls
    page = read_page wiki_state_colleges
    a_tags = page.css("#mw-content-text li a")
    a_tags.reduce([]) do |a, l|
      #regex explained: grab only those lines that have link with these specific words in them
      a << l.attributes["href"].value unless /wiki|(?:U|u)niversity|(?:C|c)ollege+$/.match(l.text).nil?
      a
    end
  end

  def read_page url
    Nokogiri::HTML(open(url))
  end
end