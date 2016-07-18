module Abilities
  class Common
    include CanCan::Ability

    def initialize(user)
      self.merge Abilities::Everyone.new(user)

      can [:read, :update], User, id: user.id

      can :read, Debate

      can :read, Proposal

      can :read, SpendingProposal


      unless user.organization?
        can :vote, Debate
        can :vote, Comment
      end

      if user.level_two_or_three_verified?

      	can :update, Debate do |debate|
        	debate.editable_by?(user)
      	end
      	
	can :update, Proposal do |proposal|
        	proposal.editable_by?(user)
      	end
	
        can [:retire_form, :retire], Proposal, author_id: user.id
	
      	can :create, Comment
      	can :create, Debate
      	can :create, Proposal

      	can :suggest, Debate
      	can :suggest, Proposal
        
      	can [:flag, :unflag], Comment
      	cannot [:flag, :unflag], Comment, user_id: user.id

      	can [:flag, :unflag], Debate
      	cannot [:flag, :unflag], Debate, author_id: user.id

      	can [:flag, :unflag], Proposal
      	cannot [:flag, :unflag], Proposal, author_id: user.id

	can :vote, Proposal
        can :vote_featured, Proposal
        can :vote, SpendingProposal
        can :create, SpendingProposal
      end

      can :create, Annotation
      can [:update, :destroy], Annotation, user_id: user.id

    end
  end
end
