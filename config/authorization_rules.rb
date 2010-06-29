authorization do

  role :guest do
    has_permission_on :qfds, :to => :view do
      if_attribute :public => is {true}
    end
  end

  role :user do
    includes :guest

    has_permission_on :qfds, :to => :manage do
      if_attribute :user => is {user}
    end

    has_permission_on :qfds, :to => :collaborate do
      if_attribute :invitations => intersects_with {user.invitations_received}
    end

    has_permission_on :hoq_lists, :to => :collaborate do
      if_permitted_to :collaborate, :qfd
    end

    has_permission_on :hoqs, :to => :collaborate do
      if_permitted_to :collaborate, :hoq_list
    end

    has_permission_on :requirements_lists, :to => :collaborate do
      if_permitted_to :collaborate, :primary_hoq
    end

    has_permission_on :requirements, :to => :collaborate do
      if_permitted_to :collaborate, :requirements_list
    end

    has_permission_on :ratings, :to => :collaborate do
      if_permitted_to :collaborate, :primary_requirement
    end

    # NOTE Seems there should be an easier way to do this
    has_permission_on :hoq_lists, :to => :manage do
      if_permitted_to :manage, :qfd
    end

    has_permission_on :hoqs, :to => :manage do
      if_permitted_to :manage, :hoq_list
    end

    has_permission_on :requirements_lists, :to => :manage do
      if_permitted_to :manage, :primary_hoq
    end

    has_permission_on :requirements, :to => :manage do
      if_permitted_to :manage, :requirements_list
    end

    has_permission_on :ratings, :to => :manage do
      if_permitted_to :manage, :primary_requirement
    end

  end

end
    
privileges do

  privilege :view do
    includes :read, :show, :download
  end

  privilege :collaborate do
    includes :view, :update
  end

  privilege :manage do
    includes :collaborate, :create, :delete, :edit, :index, :new
  end

end
