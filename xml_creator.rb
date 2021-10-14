# frozen_string_literal: true

require 'ox'

class XmlCreator
  def initialize
    @jobs_counter = 0
    @doc_xml = Ox::Document.new
    @jobs_count_xml = Ox::Element.new('jobs_count')
    @jobs_xml = Ox::Element.new('jobs')
    source_xml = Ox::Element.new('source')
    time_xml = Ox::Element.new('generation_time') << Time.now.strftime('%Y-%m-%d %H:%M:%S')

    source_xml << @jobs_count_xml << time_xml << @jobs_xml
    @doc_xml << source_xml
  end

  def add_job(title, url, location, country, city, state, zip_code, company, body)
    job_xml = Ox::Element.new('job')
    title_xml = Ox::Element.new('title') << title
    url_xml = Ox::Element.new('url') << url
    location_xml = Ox::Element.new('location') << location
    country_xml = Ox::Element.new('country') << country
    city_xml = Ox::Element.new('city') << city
    state_xml = Ox::Element.new('state') << state
    zip_code_xml = Ox::Element.new('zip_code') << zip_code
    company_xml = Ox::Element.new('company') << company
    body_xml = Ox::Element.new('body') << body

    job_xml << title_xml << url_xml << location_xml << country_xml << city_xml << state_xml \
      << zip_code_xml << company_xml << body_xml
    @jobs_xml << job_xml
    @jobs_counter += 1
  end

  def save_result(filepath, options)
    @jobs_count_xml << @jobs_counter.to_s
    Ox.to_file(filepath, @doc_xml, options)
  end
end