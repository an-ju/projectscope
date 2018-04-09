require 'rails_helper'
require 'faraday'

RSpec.describe IterationsController, type: :controller do

  describe 'show task graph' do
    before(:each) do
      @iteration = create(:iteration)
      @github_task = create(:task, :github, iteration_id: @iteration.id)
      @local_task = create(:task, :local, iteration_id: @iteration.id)
      @pivotal_task = create(:task, :pivotal, iteration_id: @iteration.id)
    end

    it "should get the all tasks iteration have" do
      expect(Task.where(iteration_id: @iteration.id)).to include @github_task
      expect(Task.where(iteration_id: @iteration.id)).to include @local_task
      expect(Task.where(iteration_id: @iteration.id)).to include @pivotal_task
    end
  end

  describe 'update all send request'do
    before(:each) do
      @iteration = create(:iteration)
      @github_task = create(:task, :github, iteration_id: @iteration.id)
      @local_task = create(:task, :local, iteration_id: @iteration.id)
      @pivotal_task = create(:task, :pivotal, iteration_id: @iteration.id)
    end

    it "identify all task that are not finished" do
      skip
    end

    let(:update_task_request) {
      Faraday.new do |builder|
        builder.adapter :test, http_stubs
      end
    }



    it "send iteration id and time_stamp to event" do
      skip
      # work when the request is able to be sent
      # todo
      # request = Faraday.new(url: '/events') do
      #  request.request :url_encoded
      # end
      uri = URI('https://api.github.com/repos/thoughtbot/factory_girl/contributors')

      response = Net::HTTP.get(uri)

      expect(response).to be_an_instance_of(String)
    end
  end

  describe 'event call back update task graph' do
    before(:each) do
      event_request = Faraday::Adapter::Test::Stubs.new
      event_request(:get, '/events/update_all').
          with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(status: 200, body: "stubbed response", headers: {})
    end

    it "gets the right thing" do
      uri = URI('/events/update_all')

      response = Net::HTTP.get(uri)

      expect(response).to be_an_instance_of(String)
    end

    it "iterate through all the unfinished task and parse them with return new events" do
      skip
    end

    it "send task to update if they are parsed in" do
      skip
    end

    it "update task if they reach requirement" do
      skip
    end

  end

  describe 'task reset' do
    before(:each) do
      @iteration = create(:iteration)
    end
    skip
  end




end
