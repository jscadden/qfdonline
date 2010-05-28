authorization do
  role :user do
    has_permission_on :qfds, :to => :alter do
      if_attribute :user => is {user}
      if_attribute :invitations => intersects_with {user.invitations_received}
    end

    has_permission_on :qfds, :to => :create
    has_permission_on :qfds, :to => :destroy do
      if_attribute :user => is {user}
    end
  end
end
    
privileges do
  privilege :alter do
    includes :read, :update
  end

end
