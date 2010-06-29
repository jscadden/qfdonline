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
    includes :create, :read, :update, :delete,
             :edit, :index, :new, :show, :download
  end

end
