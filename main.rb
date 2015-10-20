require 'httparty'
require 'pp'

EVENTBRITE_TOKEN = ENV['EVENTBRITE_TOKEN']

def get_owned_events_page(page)
  params = { :token => EVENTBRITE_TOKEN, :page => page, :status => "ended" }
  response = HTTParty.get("https://www.eventbriteapi.com/v3/users/42084127102/owned_events/", :query => params)
  pp response
  return response['events']
end

def get_owned_events()
  params = { :token => EVENTBRITE_TOKEN }
  response = HTTParty.get("https://www.eventbriteapi.com/v3/users/42084127102/owned_events/", :query => params)
  pagination = response['pagination']

  to_return = []
  page = 1

  #while page <= pagination['page_count'] do
  while page <= 1 do

    events = get_owned_events_page page

    events.each { |event|
      to_return.push event
    }

    page += 1
  end
  return to_return
end

def get_event_attendees_page(event_id, page)
  params = {:token => EVENTBRITE_TOKEN, :page => page}
  response = HTTParty.get("https://www.eventbriteapi.com/v3/events/#{event_id}/attendees/", :query => params)
  return response['attendees']
end

def get_event_attendees(event_id)
  params = { :token => EVENTBRITE_TOKEN }
  response = HTTParty.get("https://www.eventbriteapi.com/v3/events/#{event_id}/attendees/", :query => params)
  pagination = response['pagination']

  to_return = []
  page = 1

  while page <= pagination['page_count'] do

    attendees = get_event_attendees_page( event_id, page )

    attendees.each { |attendee|
      to_return.push attendee
    }

    page += 1
  end
  return to_return
end

events =  get_owned_events()

events.each { |event|
  event_id = event['id']
  event_title = event['name']['text']
  event_date = event['start']['local']

  event_attendees = get_event_attendees(event['id'])
  event_attendee_count = event_attendees.uniq.length

  puts "#{event_date}, #{event_id}, \"#{event_title}\", #{event_attendee_count}"
}



