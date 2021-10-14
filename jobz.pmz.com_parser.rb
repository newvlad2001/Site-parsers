# frozen_string_literal: true

require 'net/http'
require 'mechanize'
require './xml_creator'

agent = Mechanize.new
creator = XmlCreator.new
page = agent.get(URI('http://jobs.pmz.com/mcc/pmz/listingpage.htm'))

links = page.links_with(class: 'btn-view')
links.each do |link|
  job_page = link.click
  job_descr = job_page.search('div.six.columns > p')

  title = job_descr[0].text.strip
  url = link.href
  location = job_descr[2].text.strip
  concrete_loc = job_descr[2].text.strip.split(',')
  city = concrete_loc[0]
  state_zip = concrete_loc[1].split(' ')
  state = state_zip[0]
  zip = state_zip[1]
  company = job_descr[1].text
  body = job_page.search('div.row.top-margin.desc').text.delete!("\r\n")

  creator.add_job(title, url, location, '', city, state, zip, company, body)
end

creator.save_result('./pmz_jobs.xml', indent: 2)
