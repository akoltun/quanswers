FactoryGirl.define do
  factory :attachment do
    question
    file      Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/files/file_to_upload.txt')))
  end

end
