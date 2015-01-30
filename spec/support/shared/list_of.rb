RSpec.shared_examples "a list of" do |count, listable, attrs = [], prefix_path = ""|
  it "return list of #{listable.to_s.pluralize}" do
    expect(response.body).to have_json_size(count).at_path(prefix_path + listable.to_s.pluralize)
  end

  ([:id, :created_at, :updated_at] + (attrs || [])).each do |attr|
    it "#{listable.to_s.singularize} contains #{attr}" do
      expect(response.body).to be_json_eql(send(listable.to_s.singularize.to_sym).send(attr).to_json).at_path("#{prefix_path}#{listable.to_s.pluralize}/0/#{attr}")
    end
  end
end