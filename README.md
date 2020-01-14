# SuministrosPR Web Scraper

This is a web scraper for the SuministrosPR.com website. It was developed in order to ease transition into a new webapp developed at https://github.com/Code4PuertoRico/suministrospr.

## Instructions

You must have a working Ruby environment with `bundle` installed.

### Clone the repo

```
git clone https://github.com/Code4PuertoRico/suministrospr-web-scraper
cd suministrospr-web-scraper
```

### Install dependencies

`bundle install`

### Execute web scraper

`bundle exec suministrospr_web_scraper.rb`

## Data

Each post found at SuministrosPR.com website will be saved under the `data/raw` directory as an individual `JSON` file.

