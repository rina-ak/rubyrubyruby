class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # гость (незалогиненный)

    if user.admin?
      can :manage, :all
    elsif user.persisted?
      # Зарегистрированный пользователь
      can :read, :all
      can :create, Comment
      can :destroy, Comment, user_id: user.id if Comment.column_names.include?('user_id')
    else
      # Гость
      can :read, :all
    end
  end
end
