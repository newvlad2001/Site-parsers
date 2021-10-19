# frozen_string_literal: true

require 'mechanize'
require './xml_creator'

agent = Mechanize.new
creator = XmlCreator.new
page = agent.get('https://kiloutou.gestmax.fr/search/all-vacsearchfront_localisation-all/mobilite-afficher-tout')

loop do
  next_page_link = page.link_with(text: 'Suivant »')
  page.search('div.list-group a').each do |job|
    params = Hash.new('')
    job_page_link = page.link_with(href: job.attr('href'))
    job_page = job_page_link.click

    params[:title] = job.at('h3.list-group-item-heading').text.strip
    params[:url] = job_page_link.href
    params[:job_reference] = job_page_link.href['https://kiloutou.gestmax.fr/'.length...job_page_link.href.length]
    params[:location] = job.at('span.listdiv-span.listspan-vac_lieu_geographique').text.strip
    params[:posted_at] = job.at('div.listdiv-date').text.strip
    params[:body] = (job_page.at('div.vacancy-presentation').to_s + job_page.at('div.vacancy-text').to_s).delete("\r\n")

    creator.add_job(params)
  end
  break if next_page_link.href == '#'

  page = next_page_link.click
end

creator.save_result('./results/kiloutou.xml', indent: 2)


