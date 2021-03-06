require 'rails_helper'
require 'webmock/rspec'

describe "Teleport api" do
  before :each do
    WebMock.disable!
  end
  it "A user can get data about a given city" do

    get '/api/v1/urban_area/scores', headers: { 'HTTP_LOCATION' => "Austin, TX" }

    expect(response).to be_successful

    city_info = JSON.parse(response.body)

    city_info_keys = ["teleport_city_score", "summary", "categories"]

    expect(city_info.length).to eq(3)
    expect(city_info.keys).to eq(city_info_keys)
  end

  it "A user can get data about average salary in the nearest urban area" do

    get '/api/v1/urban_area/salaries', headers: { 'HTTP_LOCATION' => "Austin, TX" }

    expect(response).to be_successful

    city_info = JSON.parse(response.body)

    city_info_keys = ["job", "salary_percentiles"]
    city_info_job_keys = ["id", "title"]
    city_info_salary_percentile_keys = ["percentile_25", "percentile_50", "percentile_75"]

    expect(city_info.length).to eq(52)
    expect(city_info[0].keys).to eq(city_info_keys)
    expect(city_info[0]["job"].keys).to eq(city_info_job_keys)
    expect(city_info[0]["salary_percentiles"].keys).to eq(city_info_salary_percentile_keys)
  end

  it "If a city is passed in that doesn't return nearest urban area the city data is returned" do

    get '/api/v1/urban_area/scores', headers: { 'HTTP_LOCATION' => "Wheeling, WV" }

    expect(response).to be_successful

    city_info = JSON.parse(response.body)

    expect(city_info.count).to eq(3)
    expect(city_info.keys).to eq(["full_name", "population", "status"])
  end

  it "If the endpoint is hit without required headers, an error message is sent" do

    get '/api/v1/urban_area/scores'

    error_message = JSON.parse(response.body)

    expect(error_message).to eq({"error"=>"Missing location header", "status"=>400})
  end

  it "If the endpoint is hit without required headers, an error message is sent" do

    get '/api/v1/urban_area/salaries'

    error_message = JSON.parse(response.body)

    expect(error_message).to eq({"error"=>"Missing location header", "status"=>400})
  end


  it "If a city is passed in that doesn't return nearest urban area the city data is returned" do

    get '/api/v1/urban_area/salaries', headers: { 'HTTP_LOCATION' => "Wheeling, WV" }

    expect(response).to be_successful

    city_info = JSON.parse(response.body)

    expect(city_info.count).to eq(1)
    expect(city_info).to eq({"message"=>"There is no available salary data for this city."})
  end

end
