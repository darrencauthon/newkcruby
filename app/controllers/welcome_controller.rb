class WelcomeController < ApplicationController


  def index
    @meetups = []
    @meetup_members = MeetupClient.members
    @meetup_past_total = MeetupClient.past_total

    meetup = MeetupClient.calendar
    meetup["results"].each do |result|
      @meetups.push Meetup.new result
    end
  end


end

class Meetup
  attr_accessor :id, :name, :month, :day, :year, :day_of_week, :starts, :ends, :description, :venue_full_addr, :venue_name, :event_url

  def initialize meetup_response
    @id = meetup_response['id']
    @name = meetup_response['name']
    @description = meetup_response['description']
    @venue = meetup_response['venue']

    time = meetup_response['time']

    t = Time.at(time/1000)

    @month = t.strftime '%B'
    @day = t.strftime t.day.ordinalize
    @year = t.strftime '%Y'
    @starts = t.strftime '%-I'
    @day_of_week = t.strftime '%A'
    @event_url = meetup_response['event_url']

    duration = meetup_response['duration']
    if duration != nil
      dur = Time.at(t+duration/1000)
      @ends = dur.strftime '%-I'
    end

    if @venue != nil
      addr = @venue["address_1"]
      city = @venue["city"]
      state = @venue["state"]
      full_addr = addr + "," + city + "," + state

      @venue_name = @venue['name']
      @venue_full_addr = full_addr
    end

  end

end