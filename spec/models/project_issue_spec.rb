require 'rails_helper'

RSpec.describe ProjectIssue, type: :model do
  context 'codecimate_report' do
    before :each do
      @project = create(:project)
      @m1 = create(:codeclimate_report, project: @project)
      @m2 = create(:codeclimate_report, project: @project)
    end

    describe 'test_coverage_drop' do
      it 'detects the issue' do
        expect(described_class).to receive(:create)
        described_class.test_coverage_drop(@project, @m2.data_version)
      end
    end

    describe 'low_test_coverage' do
      it 'detects the issue' do
        expect(described_class).to receive(:create)
        described_class.low_test_coverage(@project, @m2.data_version)
      end
    end
  end
end
