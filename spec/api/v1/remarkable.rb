require 'rails_helper'

RSpec.shared_examples "a remarkable" do |remarkable|
  context 'remarks' do
    it "included in #{remarkable} object" do
      expect(response.body).to have_json_size(1).at_path("#{remarkable}/remarks")
    end

    [:id, :remark, :created_at, :updated_at].each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(remark.send(attr).to_json).at_path("#{remarkable}/remarks/0/#{attr}")
      end
    end
  end
end