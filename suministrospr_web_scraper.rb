#!/usr/bin/env ruby

require 'i18n'
require 'kimurai'
require 'mechanize'
require 'sanitize'

I18n.config.available_locales = :en

class SuministrosPR < Kimurai::Base
  @name = "suministrospr-scraper"
  @engine = :mechanize
  @start_urls = ["https://suministrospr.com/"]
  @config = {
    user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.84 Safari/537.36",
    before_request: { delay: 1 }
  }

  def parse(response, url:, data: {})
    # Go to the main page, find all links related to a 'sector' page and parse each one individually.
    response.xpath("//a[starts-with(@href, 'https://suministrospr.com/sectores/')]").each do |a|
      request_to :parse_sector_page, url: a[:href]
    end
  end

  def parse_sector_page(response, url:, data: {})
    sector_data = {}
    sector_data[:url] = url
    sector_data[:municipio] = response.xpath("//div[@class='breadcrumbs pauple_helpie_breadcrumbs']/a[@class='mainpage-link'][starts-with(@href, 'https://suministrospr.com/municipios/')][position()=1]").text
    sector_data[:title] = response.xpath("//h1").text
    sector_data[:content] = Sanitize.fragment(response.xpath("//div[@class='article-content']").to_html, Sanitize::Config::BASIC).strip!

    sector_json = File.join(__dir__, "data/#{I18n.transliterate(sector_data[:title])}.json")
    save_to sector_json, sector_data, format: :pretty_json
  end
end

SuministrosPR.crawl!
