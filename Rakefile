# encoding: UTF-8

require File.expand_path('suministrospr_web_scraper.rb', __dir__)
require 'zip'

I18n.config.available_locales = :en
HELP_COMMANDS = <<~HELP.freeze
  SuministrosPR Web Scraper Help:

    bundle exec rake help - Shows command description.
    bundle exec rake boom - Runs all commands (clean, crawl, zip).
    bundle exec rake docker - Runs all commands inside a docker container.
    bundle exec rake data:clean - Deletes JSON files in the data directory.
    bundle exec rake data:crawl - Executes web scraper and gets data.
    bundle exec rake data:zip - Zip all JSON files in the data directory.
HELP
TIME_STRFMT = "%Y%m%d-%H%M%S".freeze

# Rake tasks to simplify execution.
task default: [:help]

task :help do
  puts HELP_COMMANDS
end

task :boom do
  Rake::Task['data:crawl'].execute
  Rake::Task['data:zip'].execute
end

task :docker do
  sh 'docker image rm suministrospr-web-scraper'
  sh 'docker build --rm -t suministrospr-web-scraper .'
  sh 'docker run -it --rm -v "$PWD":/usr/src/app suministrospr-web-scraper bundle exec rake boom'
end

namespace :data do
  task :clean do
    puts 'Cleaning data directory...'
    Dir[SuministrosPR::ALL_DATA_FILES_PATH].each do |json_file|
      puts "Deleting #{json_file}"
      File.delete json_file
    end
    puts 'Cleaning complete!'
  end

  task :crawl do
    # Create data directory.
    Dir.mkdir(SuministrosPR::DATA_DIR) unless File.exist?(SuministrosPR::DATA_DIR)
    # Cleanup data directory.
    Rake::Task['data:clean'].execute
    # Execute SuministrosPR.com web scraper!
    SuministrosPR.crawl!
  end

  task :zip do
    zip_filename = "suministrospr-data-#{Time.now.strftime(TIME_STRFMT)}.zip"
    zip_archive = File.join(SuministrosPR::DATA_DIR, zip_filename)

    if Dir[SuministrosPR::ALL_DATA_FILES_PATH].empty?
      puts 'No JSON files found.'
    else
      files_added = 0
      Zip::File.open(zip_archive, Zip::File::CREATE) do |zip|
        puts "Created zip file: #{zip_filename}"
        Dir[SuministrosPR::ALL_DATA_FILES_PATH].each do |json_filepath|
          json_filename = File.basename(json_filepath)
          puts "Adding: #{json_filename}"
          zip.add(json_filename, json_filepath)
          files_added += 1
        end
      end
      puts "#{files_added} files added."
    end
  end
end
