# frozen_string_literal: true

require 'ox'

# Class for creating XML of the following format:
#   <jobs>
#     <job>
#       <job_parameter1>
#       <job_parameter2>
#       ...
class XmlCreator
  def initialize
    @jobs_counter = 0
    @doc_xml = Ox::Document.new

    jobs_count_xml = Ox::Element.new('jobs_count')
    jobs_xml = Ox::Element.new('jobs')
    source_xml = Ox::Element.new('source')
    time_xml = Ox::Element.new('generation_time') << Time.now.strftime('%Y-%m-%d %H:%M:%S %z')

    source_xml << jobs_count_xml << time_xml << jobs_xml
    @doc_xml << source_xml
  end

  # Creates a job with the specified parameters
  # @param params [Hash] Job parameters
  # @option params [String] :title ('') Job title
  # @option params [String] :url ('') Page url with full job description
  # @option params [String] :job_reference ('') Job reference
  # @option params [String] :location ('') Job location
  # @option params [String] :city ('') Job location city
  # @option params [String] :state ('') Job location state
  # @option params [String] :country ('') Job location country
  # @option params [String] :zip_code ('') Job location zip code
  # @option params [String] :req_number ('') Job requisition number
  # @option params [String] :posted_at ('') Job posting date
  # @option params [String] :company ('') Hiring organization
  # @option params [String] :body ('') Job full description text
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
    @doc_xml.source.jobs << job_xml
    @jobs_counter += 1
  end

  # Saves XML to the file
  # @param filepath [String] File path to write the XML document to
  # @param options [Hash] Formatting options
  # @option options [Fixnum] :indent Format expected
  # @see Ox.to_file
  def save_result(filepath, options)
    @doc_xml.source.jobs_count << @jobs_counter.to_s
    Ox.to_file(filepath, @doc_xml, options)
  end
end
