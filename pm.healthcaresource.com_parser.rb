# frozen_string_literal => true

require 'mechanize'
require 'json'
require './xml_creator'

agent = Mechanize.new
creator = XmlCreator.new

headers = {
  'Host' => 'pm.healthcaresource.com',
  'Connection' => 'keep-alive',
  'Content-Type' => 'application/json; charset=UTF-8',
  'X-Requested-With' => 'XMLHttpRequest',
  'sec-ch-ua-platform' => '"Windows"',
  'Origin' => 'https://pm.healthcaresource.com',
  'Sec-Fetch-Site' => 'same-origin',
  'Sec-Fetch-Mode' => 'cors',
  'Sec-Fetch-Dest' => 'empty',
  'Referer' => 'https://pm.healthcaresource.com/cs/chc',
  'Accept-Encoding' => 'gzip, deflate, br',
  'Accept-Language' => 'en-US,en;q=0.9'
}
params = '{
            "query":{
              "bool":{"must":{"match_all":{}},
              "should":{"match":{"userArea.isFeaturedJob":{"query":true,"boost":1}}}}},
              "sort":{"title.raw":"asc"},
              "aggs":{"facility":{"terms":{"field":"userArea.bELevel1.raw","size":1000}},
              "occupationalCategory":{"terms":{"field":"occupationalCategory.raw","size":1000}},
              "employmentType":{"terms":{"field":"employmentType.raw","size":1000}}
            }
          }'

agent.post('https://pm.healthcaresource.com/JobseekerSearchAPI/chc/api/Search?size=10000', params, headers)
data = JSON.parse(agent.page.body)

url = 'https://pm.healthcaresource.com/cs/chc#/job/'
data['hits']['hits'].each do |job|
  job = job['_source']
  params = Hash.new('')

  params[:title] = job['title']
  params[:url] = url + job['userArea']['jobPostingID'].to_s
  params[:job_reference] = job['userArea']['jobPostingID'].to_s
  location = job['jobLocation']['address']
  params[:location] = "#{location['streetAddress']}, #{location['addressLocalityRegion']}"
  params[:city] = location['addressLocality']
  params[:state] = location['addressRegion']
  params[:zip_code] = location['postalCode']
  params[:req_number] = job['userArea']['requisitionNumber']
  params[:posted_at] = job['datePosted']
  params[:company] = job['hiringOrganization']['subOrganization']['name']
  params[:body] = job['userArea']['jobSummaryDisplay'].to_s.delete("\r\n")

  creator.add_job(params)
end

creator.save_result('./results/healthcare_jobs.xml', indent: 2)

