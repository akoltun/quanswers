class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Question

    if user
      cannot :confirm, UserConfirmationRequest
      can :see, :author
      can :create, [Question, Answer, Remark]
      can [:update, :destroy], Question do |question|
        question.answers.empty? && question.user == user
      end
      can [:update, :destroy], [Answer, Remark], user: user
      can :set_as_best, Answer, question: { user: user }
    end
  end
end
