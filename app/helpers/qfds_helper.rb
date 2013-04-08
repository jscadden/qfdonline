module QfdsHelper

  def link_to_invite_a_collaborator(qfd)
    link_to("Invite A Collaborator", 
            new_invitation_path(:invitation => {:qfd_id => qfd.id}))
  end

  def permissions_on_qfd_for_current_user(qfd)
    if qfd.user == current_user
      "Owner"
    elsif qfd.public 
      "Read-Only"
    elsif Qfd.with_permissions_to(:collaborate).include?(qfd)
      "Collaborator"
    elsif Qfd.with_permissions_to(:view).include?(qfd)
      "Collaborator (RO)"
    else
      raise "Unknown permissions for #{current_user.inspect} on #{qfd.inspect}"
    end
  end
end
