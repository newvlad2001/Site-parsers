# frozen_string_literal: true

require 'ox'

class XmlCreator
  def initialize
    @jobs_counter = 0
    @doc_xml = Ox::Document.new
    @jobs_count_xml = Ox::Element.new('jobs_count')
    @jobs_xml = Ox::Element.new('jobs')
    source_xml = Ox::Element.new('source')
    time_xml = Ox::Element.new('generation_time') << Time.now.strftime('%Y-%m-%d %H:%M:%S %z')

    source_xml << @jobs_count_xml << time_xml << @jobs_xml
    @doc_xml << source_xml
  end

  def add_job(params)
    job_xml = Ox::Element.new('job')
    title_xml = Ox::Element.new('title') << params[:title]
    url_xml = Ox::Element.new('url') << params[:url]
    job_reference_xml = Ox::Element.new('job_reference') << params[:job_reference]
    location_xml = Ox::Element.new('location') << params[:location]
    city_xml = Ox::Element.new('city') << params[:city]
    state_xml = Ox::Element.new('state') << params[:state]
    country_xml = Ox::Element.new('country') << params[:country]
    zip_code_xml = Ox::Element.new('zip_code') << params[:zip_code]
    req_number_xml = Ox::Element.new('req_number') << params[:req_number]
    posted_at_xml = Ox::Element.new('posted_at') << params[:posted_at]
    company_xml = Ox::Element.new('company') << params[:company]
    body_xml = Ox::Element.new('body') << params[:body]

    job_xml << title_xml << url_xml << job_reference_xml << location_xml << country_xml << city_xml << state_xml \
      << zip_code_xml << req_number_xml << posted_at_xml << company_xml << body_xml
    @jobs_xml << job_xml
    @jobs_counter += 1
  end

  def save_result(filepath, options)
    @jobs_count_xml << @jobs_counter.to_s
    Ox.to_file(filepath, @doc_xml, options)
  end
end