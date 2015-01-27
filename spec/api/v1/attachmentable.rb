require 'rails_helper'

RSpec.shared_examples "an attachmentable" do |attachmentable|
  context 'attachments' do
    it "included in #{attachmentable} object" do
      expect(response.body).to have_json_size(1).at_path("#{attachmentable}/attachments")
    end

    [:id, :created_at, :updated_at].each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(attachment.send(attr).to_json).at_path("#{attachmentable}/attachments/0/#{attr}")
      end
    end

    it "contains filename" do
      expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("#{attachmentable}/attachments/0/filename")
    end
    it "contains url" do
      expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{attachmentable}/attachments/0/url")
    end
  end
end