require 'open-uri'
require 'json'
require 'yaml'

KEYS = YAML.load(File.open("./config/application.yml", 'r'))

OAUTH_TOKEN = KEYS['keys'][0]['OAUTH_TOKEN']
API_KEY = KEYS['keys'][0]['API_KEY']

SUBCATEGORIES_URL = 'https://www.eventbriteapi.com/v3/subcategories/'
EVENTS_URL = 'https://www.eventbriteapi.com/v3/events/search/?'

LOCATION_PREFIX = 'location.address='
PAGE_PREFIX = 'page='
TOKEN_PREFIX = 'token='
SUBCATEGORY_PREFIX = 'subcategories='

def event_names_list(city)
  url_no_page = "#{EVENTS_URL}#{LOCATION_PREFIX}" + city + "&#{TOKEN_PREFIX}#{OAUTH_TOKEN}&#{PAGE_PREFIX}"
  event_names = []
  (1..10).each do |i|
    url = url_no_page + "#{i}"
    events = JSON.parse(open(url).read)
    events["events"].each do|event|
      event_names << event["name"]["text"]
    end
  end
  event_names.each do |event_name|
    p event_name
  end
end

def subcategories_and_ids_list
  url_no_page = "#{SUBCATEGORIES_URL}?#{TOKEN_PREFIX}#{OAUTH_TOKEN}&#{PAGE_PREFIX}"
  subcategory_names_and_ids = []
  (1..4).each do |i|
    url = url_no_page + "#{i}"
    subcategories = JSON.parse(open(url).read)
    subcategories["subcategories"].each do|subcategory|
      subcategory_names_and_ids << [subcategory["name"], subcategory["id"]]
    end
  end
  subcategory_names_and_ids.sort!
end

def event_names_list(city, subcategory)
  subcategory_and_id = subcategories_and_ids_list.select { |pair| pair[0].downcase == subcategory }
  url_no_page = "#{EVENTS_URL}#{LOCATION_PREFIX}" + city + "&#{SUBCATEGORY_PREFIX}" + subcategory_and_id[0][1] + "&#{TOKEN_PREFIX}#{OAUTH_TOKEN}" + "&#{PAGE_PREFIX}"
  event_names_and_venue_ids = []
  (1..10).each do |i|
    url = url_no_page + "#{i}"
    events = JSON.parse(open(url).read)
    events["events"].each do|event|
      event_names_and_venue_ids << {name: event["name"]["text"], venue_id: event["venue_id"]}
    end
  end
  return event_names_and_venue_ids
end

# p event_names_list("london", "edm / electronic")



