RSpec.shared_examples "a taggable" do
  describe "#tags_list" do
    context "when there is not tags" do
      it "returns empty string" do
        expect(subject.tags_list).to eq ''
      end
    end

    context "when there are tags" do
      before { subject.tags << create_list(:tag, 3) }

      it "returns tags separated by comma" do
        expect(subject.tags_list).to eq subject.tags.pluck(:name).join(', ')
      end
    end
  end

  describe "#tags_list = value" do
    let(:update_tags) { subject.update!(tags_list: value) }

    context "when value contains not all present tags" do
      before { subject.tags << create_list(:tag, 3) }
      let(:value) { subject.tags.last.name }

      it "does not delete tags from tags table" do
        expect { update_tags }.not_to change(Tag, :count)
      end

      it "deattaches tags that are not in the value list from subject" do
        expect { update_tags }.to change(subject.tags, :count).by(-2)
      end

      it "keeps tags from value list in subject" do
        update_tags

        expect(subject.tags.first.name).to eq value
      end
    end

    context "when value contains new tags" do
      let(:tag_names) { ['abc', 'def', 'klmn'] }
      let(:value) { tag_names.join(', ') }

      it "creates new tags in tags table" do
        expect { update_tags }.to change(Tag, :count).by(tag_names.size)
      end

      it "creates new tags with correct names" do
        update_tags

        Tag.find_each do |tag|
          expect(tag_names).to include(tag.name)
        end
      end

      it "attaches new tags to subject" do
        expect { update_tags }.to change(subject.tags, :count).by(tag_names.size)
      end

      it "attaches each new tag to subject" do
        update_tags

        subject.tags.find_each do |tag|
          expect(tag_names).to include(tag.name)
        end
      end
    end

    context "when value contains not all present tags and some new tags" do
      before { subject.tags << create_list(:tag, 3) }
      let(:old_tag_name) { subject.tags.last.name }
      let(:new_tag_name) { 'abc' }
      let(:value) { "#{old_tag_name}, #{new_tag_name}" }

      it "doesn't delete tags from but creates new tag in tags table" do
        expect { update_tags }.to change(Tag, :count).by(1)
      end

      it "creates new tag with correct name" do
        update_tags

        expect(Tag.pluck(:name)).to include(new_tag_name)
      end

      it "deattaches from and attaches tags to subject" do
        expect { update_tags }.to change(subject.tags, :count).by(-1)
      end

      it "attaches new tag to subject" do
        update_tags
        expect(subject.tags.pluck(:name)).to include(new_tag_name)
      end

      it "keeps old tags from value list in subject" do
        update_tags

        expect(subject.tags.pluck(:name)).to include(old_tag_name)
      end
    end
  end
end