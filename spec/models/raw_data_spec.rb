require 'rails_helper'

describe RawData, type: :model do
  describe 'self.register' do
    it 'creates a new raw_data record from given metric_sample' do
      metric_sample = build(:metric_sample, raw_data: { test: { data: 'test data'} } )
      expect { described_class.register(metric_sample) }.to change { RawData.count }.by(1)
    end

    it 'collects all data from metric_sample' do
      metric_sample = build(:metric_sample,
                            raw_data: { test1: { data: 'data 1'},
                                        test2: { data: 'data 2'} } )
      expect { described_class.register(metric_sample) }.to change { RawData.count }.by(2)
    end
  end

end