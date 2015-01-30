RSpec.shared_examples "a publisher on question page of" do |object|
  it "publishes new #{object}" do
    expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}", hash_including(object=>hash_including(publishing_hash)))
    expect(PrivatePub).to receive(:publish_to).with("/signed_in/questions/#{question.id}", hash_including(object=>hash_including(publishing_hash.merge("user_id"=>@user.id, "author"=>@user.username))) )
    allow(PrivatePub).to receive(:publish_to).with(/\/questions$/, anything())
    do_request
  end

  it "publishes new #{object} without author for unauthorized users" do
    expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}", hash_including(object=>hash_excluding("user_id"=>@user.id, "author"=>@user.username)))
    expect(PrivatePub).to receive(:publish_to).with("/signed_in/questions/#{question.id}", hash_including(object=>hash_including(publishing_hash.merge("user_id"=>@user.id, "author"=>@user.username))) )
    allow(PrivatePub).to receive(:publish_to).with(/\/questions$/, anything())
    do_request
  end
end