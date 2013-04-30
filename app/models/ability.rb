class Ability
  include CanCan::Ability

  @@permissions = nil

  def initialize(user)
    self.clear_aliased_actions

    alias_action :index, :show, :to => :read
    alias_action :new,          :to => :create
    alias_action :edit,         :to => :update
    alias_action :destroy,      :to => :delete

    user ||= User.new

    # super user can do everything
    if user.has_role? :admin
      can :manage, :all
    else
      # edit update self
      #cannot :read, Permission
      can :read, User do |resource|
        resource == user
      end
      can :update, User do |resource|
        resource == user
      end
      # enables signup
      can :create, User

      user.roles.each do |role|
        if role.permissions
          role.permissions.each do |permission|
            can permission.action.to_sym, permission.subject_class.constantize
          end
        end
      end
    end
  end

  def self.permissions
    @@permissions ||= Ability.load_permissions
  end

  def self.load_permissions(file='permissions.yml')
    Permission.all
  end
end


#class Ability
#  include CanCan::Ability
#
#  def initialize(user)
#    user ||= User.new
#    if user.has_role? :admin
#      can :manage, :all
#    else
#      can :read, :all
#      #can do |action, subject_class, subject|
#      #  user.permissions.find_all_by_action(aliases_for_action(action)).any? do |permission|
#      #    permission.subject_class == subject_class.to_s &&
#      #        (subject.nil? || permission.subject_id.nil? || permission.subject_id == subject.id)
#      #  end
#      #end
#    end
#  end
#
#  #def initialize(user)
#  #  user ||= User.new
#  #  can :manage, Query, :user_id => user.id
#  #
#  #  if user.has_role? :admin
#  #    can :manage, :all
#  #  elsif user.has_role? :moderator
#  #    can :manage, User
#  #    can :manage, Authentication
#  #    can :manage, Company
#  #    can :manage, Education, :user_id => user.id
#  #    can :manage, Position, :user_id => user.id
#  #    can :manage, Url, :user_id => user.id
#  #    can :manage, :versions
#  #  else
#  #    can :manage, User, :id => user.id
#  #    can :manage, Authentication, :user_id => user.id
#  #    can :manage, Company
#  #    can :manage, Education, :user_id => user.id
#  #    can :manage, Position, :user_id => user.id
#  #    can :manage, Url, :user_id => user.id
#  #    can :manage, :versions
#  #  end
#  #
#  #  # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
#  #end
#end
