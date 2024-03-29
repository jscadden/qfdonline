require "authlogic/test_case"

def current_user(stubs = {})
  stubs = stubs.reverse_merge(:role_symbols => [:user,])
  @current_user ||= mock_model(User, stubs)
end
 
def user_session(stubs = {}, user_stubs = {})
  @current_user_session ||= mock_model(UserSession, {:user => current_user(user_stubs)}.merge(stubs))
end
 
def login(session_stubs = {}, user_stubs = {})
  UserSession.stub!(:find).and_return(user_session(session_stubs, user_stubs))
end
 
def logout
  @current_user_session = nil
  @current_user = nil
end
