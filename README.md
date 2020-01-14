# SuministrosPR Web Scraper

This is a web scraper for the [SuministrosPR.com](https://SuministrosPR.com) website. It was developed in order to extract the data and ingest it into a new webapp developed at https://github.com/Code4PuertoRico/suministrospr.

## Instructions

You must have a working Ruby environment with version `2.6.5` and [Bundler](https://bundler.io/) installed.

### Clone the repo

```bash
git clone https://github.com/Code4PuertoRico/suministrospr-web-scraper
cd suministrospr-web-scraper
```

### Install dependencies

```ruby
bundle install
```

### Execute web scraper

```ruby
bundle exec suministrospr_web_scraper.rb
```

## Data

Each post found at [SuministrosPR.com](https://SuministrosPR.com) will be saved under the `./data` directory as an individual `JSON` file.
