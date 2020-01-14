#!/usr/bin/env ruby

require 'kimurai'
require 'mechanize'
require 'i18n'

class SuministrosPR < Kimurai::Base
  @name = "suministrospr-scraper"
  @engine = :mechanize
  @start_urls = ["https://suministrospr.com/"]
  @config = {
    user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.84 Safari/537.36",
    before_request: { delay: 1 }
  }

  def parse(response, url:, data: {})
    # Load one municipality page and parse all the links to 
    response.xpath("//a[starts-with(@href, 'https://suministrospr.com/sectores/')]").each do |a|
      request_to :parse_sector_page, url: a[:href]
    end
  end

  def parse_sector_page(response, url:, data: {})
    sector_data = {}
    sector_data[:url] = url
    sector_data[:municipio] = response.xpath("//div[@class='breadcrumbs pauple_helpie_breadcrumbs']/a[starts-with(@href, 'https://suministrospr.com/municipios/')]").text
    sector_data[:title] = response.xpath("//h1").text
    sector_data[:content] = response.xpath("//div[@class='article-content']").to_html

    sector_json = "./data/raw/#{I18n.transliterate(sector_data[:title])}.json"
    save_to sector_json, sector_data, format: :pretty_json
  end
end

SuministrosPR.crawl!
