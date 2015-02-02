require 'rails_helper'

RSpec.describe Tag, :type => :model do
  it { is_expected.to have_db_index(:name).unique(true)  }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to strip_attribute(:name).collapse_spaces }
  it { is_expected.to have_and_belong_to_many(:questions) }

  context "created with uppercase letters" do
    let(:tag) { create(:tag, name: 'AbcDEf') }

    it "transforms name to lowercase" do
      expect(tag.name).to eq 'abcdef'
    end
  end

  it "ensure name does not contain comma" do
    expect(Tag.create(name: 'ab,cd').errors[:name]).to include "can't contain comma"
  end

  context "#color_index" do
    it "equal to 0 for first tag" do
      expect(create(:tag).color_index).to eq 0
    end

    it "increased by 1 for each next tag" do
      expect(create_list(:tag, 2).last.color_index).to eq 1
    end
  end
end
