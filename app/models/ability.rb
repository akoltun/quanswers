class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Question

    if user
      can :see, :author
      can :create, [Question, Answer, Remark]
      can [:update, :destroy], Question do |question|
        question.answers.empty? && question.user == user
      end
      can [:update, :destroy], [Answer, Remark], user: user
      can :set_as_best, Answer, question: { user: user }

      can :rating, [Question, Answer]
      cannot :rating, [Question, Answer], user: user

      can [:follow, :unfollow], Question
      cannot [:follow, :unfollow], Question, user: user

      if user.admin
        can :manage, :oauth_application
      end
    end
  end
end
