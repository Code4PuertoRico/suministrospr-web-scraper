# encoding: UTF-8

require 'i18n'
require 'kimurai'
require 'mechanize'
require 'sanitize'

class SuministrosPR < Kimurai::Base
  DATA_DIR = File.expand_path('data', __dir__).freeze
  ALL_DATA_FILES_PATH = File.join(DATA_DIR, '*.json').freeze

  @name = "suministrospr-web-scraper"
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
    # Parse elements.
    municipio = response.xpath("//div[@class='breadcrumbs pauple_helpie_breadcrumbs']/a[@class='mainpage-link'][starts-with(@href, 'https://suministrospr.com/municipios/')][position()=1]").text.strip
    title = response.xpath("//h1").text.strip
    content = Sanitize.fragment(response.xpath("//div[@class='article-content']").to_html, Sanitize::Config::BASIC).strip

    # Create hash that will be serialized to JSON.
    sector_data = {}
    sector_data[:url] = url
    sector_data[:municipio] = municipio.empty? ? 'EMPTY_MUNICIPIO' : municipio
    sector_data[:title] = title.empty? ? 'EMPTY_TITLE' : title
    sector_data[:content] = content

    # Get current time and use in filename if sector has no title or file already exists.
    timestamp = Time.now.to_i
    # Construct filename.
    json_filename = if title.empty?
      # Using timestamp in filename if title is empty.
      "#{I18n.transliterate(municipio)}-EMPTY_TITLE-#{timestamp}.json"
    else
      # Transliterating title to ASCII and using as filename.
      "#{I18n.transliterate(municipio)}-#{I18n.transliterate(title).slice(0,100)}.json"
    end
    # Adding timestamp to filename if a file with that name already exists.
    if File.exist?(File.join(DATA_DIR, json_filename))
      json_filename = "#{File.basename(json_filename, ".json")}-DUPLICATE-#{timestamp}.json"
    end

    # Saving parsed data to JSON file.
    json_filepath = File.join(DATA_DIR, json_filename)
    save_to json_filepath, sector_data, format: :pretty_json
  end
end
