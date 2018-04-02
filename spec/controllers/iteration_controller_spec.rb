require 'rails_helper'

RSpec.describe IterationsController, type: :controller do

  describe 'event call back' do
    before(:each) do
      @iteration = create(:iteration)
    end
    skip
  end

  describe 'task reset' do
    before(:each) do
      @iteration = create(:iteration)
    end
    skip
  end

  describe 'show' do
    before(:each) do
      @iteration = create(:iteration)
    end
    skip
  end

  describe 'update all'do
    before(:each) do
      @iteration = create(:iteration)
      @task = create(:task)
    end
    it "should get the all tasks iteration have" do

    end
  end
end
