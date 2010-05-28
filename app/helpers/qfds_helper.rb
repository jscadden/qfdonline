module QfdsHelper

  def link_to_invite_a_collaborator(qfd)
    link_to("Invite A Collaborator", 
            new_invitation_path(:invitation => {:qfd_id => qfd.id}))
  end

end
