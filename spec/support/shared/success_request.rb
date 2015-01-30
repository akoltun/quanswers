RSpec.shared_examples "a success request" do
  it "returns 200 status" do
    expect(response).to be_success
  end
end