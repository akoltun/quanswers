require 'rails_helper'

RSpec.describe Attachment, :type => :model do
  it { is_expected.to belong_to :attachmentable }

  it { is_expected.to have_db_index([:attachmentable_type, :attachmentable_id]).unique(false) }
end
