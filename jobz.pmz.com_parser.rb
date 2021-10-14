# frozen_string_literal: true

require 'net/http'
require 'mechanize'
require './xml_creator'

agent = Mechanize.new
creator = XmlCreator.new
page = agent.get(URI('http://jobs.pmz.com/mcc/pmz/listingpage.htm'))

links = page.links_with(class: 'btn-view')[0...5]
links.each do |link|
  job_page = link.click
  job_descr = job_page.search('div.six.columns > p')
  dictionary = Hash.new('')

  dictionary[:title] = job_descr[0].text.strip
  dictionary[:url] = link.href
  dictionary[:location] = job_descr[2].text.strip
  concrete_loc = job_descr[2].text.strip.split(',')
  dictionary[:city] = concrete_loc[0]
  state_zip = concrete_loc[1].split(' ')
  dictionary[:state] = state_zip[0]
  dictionary[:zip_code] = state_zip[1]
  dictionary[:company] = job_descr[1].text
  dictionary[:body] = job_page.search('div.row.top-margin.desc').text.delete!("\r\n")

  creator.add_job(dictionary)
end

creator.save_result('./pmz_jobs.xml', indent: 2)
