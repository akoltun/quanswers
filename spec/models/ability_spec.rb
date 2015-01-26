require 'rails_helper'

RSpec.describe Ability, :type => :model do
  subject { Ability.new(user) }

  describe "non-authenticated user" do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }

    it { is_expected.not_to be_able_to :see, :author }

    it { is_expected.not_to be_able_to :create, Question }
    it { is_expected.not_to be_able_to :create, Answer }
    it { is_expected.not_to be_able_to :create, Remark }

    it { is_expected.not_to be_able_to :update, Question }
    it { is_expected.not_to be_able_to :update, Answer }
    it { is_expected.not_to be_able_to :update, Remark }

    it { is_expected.not_to be_able_to :destroy, Question }
    it { is_expected.not_to be_able_to :destroy, Answer }
    it { is_expected.not_to be_able_to :destroy, Remark }

    it { is_expected.not_to be_able_to :set_as_best, Answer }

    it { is_expected.not_to be_able_to :rating, Question }
    it { is_expected.not_to be_able_to :rating, Answer }
  end

  describe "authenticated user" do
    let(:user) { create(:user) }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :see, :author }

    it { is_expected.to be_able_to :create, Question }
    it { is_expected.to be_able_to :create, Answer }
    it { is_expected.to be_able_to :create, Remark }

    it { is_expected.to be_able_to :update, create(:question, user: user) }
    it { is_expected.to be_able_to :update, create(:answer, user: user) }
    it { is_expected.to be_able_to :update, create(:remark, user: user, remarkable: create(:question)) }
    it { is_expected.to be_able_to :update, create(:remark, user: user, remarkable: create(:answer)) }

    it { is_expected.not_to be_able_to :update, create(:question) }
    it { is_expected.not_to be_able_to :update, create(:answer) }
    it { is_expected.not_to be_able_to :update, create(:remark, remarkable: create(:question)) }
    it { is_expected.not_to be_able_to :update, create(:remark, remarkable: create(:answer)) }

    it { is_expected.not_to be_able_to :update, create(:question_with_answers, user: user) }

    it { is_expected.to be_able_to :destroy, create(:question, user: user) }
    it { is_expected.to be_able_to :destroy, create(:answer, user: user) }
    it { is_expected.to be_able_to :destroy, create(:remark, user: user, remarkable: create(:question)) }
    it { is_expected.to be_able_to :destroy, create(:remark, user: user, remarkable: create(:answer)) }

    it { is_expected.not_to be_able_to :destroy, create(:question) }
    it { is_expected.not_to be_able_to :destroy, create(:answer) }
    it { is_expected.not_to be_able_to :destroy, create(:remark, remarkable: create(:question)) }
    it { is_expected.not_to be_able_to :destroy, create(:remark, remarkable: create(:answer)) }

    it { is_expected.not_to be_able_to :destroy, create(:question_with_answers, user: user) }

    it { is_expected.to be_able_to :set_as_best, create(:answer, question: create(:question, user: user)) }
    it { is_expected.not_to be_able_to :set_as_best, create(:answer) }

    it { is_expected.to be_able_to :rating, Question }
    it { is_expected.not_to be_able_to :rating, create(:question, user: user) }

    it { is_expected.to be_able_to :rating, Answer }
    it { is_expected.not_to be_able_to :rating, create(:answer, user: user) }
  end
end