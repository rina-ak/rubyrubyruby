class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.persisted?
      can :read, Album
      can :search, Album
      can :read, ThematicSection
      can :create, Comment
      can :destroy, Comment, user_id: user.id
      can :create, AlbumProposal
    else
      can :read, Album
      can :search, Album
      can :read, ThematicSection
      can :create, AlbumProposal
    end
  end
end
