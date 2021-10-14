# frozen_string_literal: true

require 'net/http'
require 'mechanize'
require 'ox'

agent = Mechanize.new
page = agent.get(URI('http://jobs.pmz.com/mcc/pmz/listingpage.htm'))

doc = Ox::Document.new
source = Ox::Element.new('source')
jobs_count = Ox::Element.new('jobs_count')
time = Ox::Element.new('generation_time')
jobs = Ox::Element.new('jobs')

doc << source
source << jobs_count << time << jobs

links = page.links_with(class: 'btn-view')[0...5]

jobs_count << links.count.to_s
time << Time.now.strftime("%Y-%m-%d %H:%M:%S")

links.each do |link|
  job = Ox::Element.new('job')
  jobs << job

  job_page = link.click
  job_descr = job_page.search('div.six.columns > p')

  job_title = Ox::Element.new('title')
  job_title << job_descr[0].text.strip

  job_descr_link = Ox::Element.new('url')
  job_descr_link << link.href

  job_location = Ox::Element.new('location')
  job_location << job_descr[2].text.strip

  job_concrete_loc = job_descr[2].text.strip.split(',')
  city = Ox::Element.new('city')
  city << job_concrete_loc[0]

  state_zip = job_concrete_loc[1].split(' ')
  state = Ox::Element.new('state')
  state << state_zip[0]

  zip = Ox::Element.new('zip_code')
  zip << state_zip[1]

  company = Ox::Element.new('company')
  company << job_descr[1].text

  job_full_descr = Ox::Element.new('body')
  job_full_descr << job_page.search('div.row.top-margin.desc').text.delete!("\r\n")

  job << job_title << job_descr_link << job_location << city << state << zip << company << job_full_descr
end

Ox.to_file('.\pmz_jobs.xml', doc, indent: 3)
