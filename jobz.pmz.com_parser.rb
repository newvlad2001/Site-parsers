# frozen_string_literal: true

require 'mechanize'
require './xml_creator'

agent = Mechanize.new
creator = XmlCreator.new
page = agent.get('http://jobs.pmz.com/mcc/pmz/listingpage.htm')

links = page.links_with(class: 'btn-view')
links.each do |link|
  job_page = link.click
  job_descr = job_page.search('div.six.columns > p')
  params = Hash.new('')

  params[:title] = job_descr[0].text.strip
  params[:url] = link.href
  params[:job_reference] = link.href[(link.href.rindex('/') + 1)...link.href.length]
  params[:location] = job_descr[2].text.strip
  concrete_loc = job_descr[2].text.strip.split(',')
  params[:city] = concrete_loc[0]
  state_zip = concrete_loc[1].split(' ')
  params[:state] = state_zip[0]
  params[:zip_code] = state_zip[1]
  params[:company] = job_descr[1].text
  params[:body] = job_page.search('div.row.top-margin.desc').to_s.delete("\r\n")

  creator.add_job(params)
end

creator.save_result('./results/pmz_jobs.xml', indent: 2)
