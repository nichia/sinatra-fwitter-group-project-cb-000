class Helpers

  def self.current_user(session)
    if !session[:user_id].nil?
      User.find_by_id(session[:user_id])
    end
  end

  def self.logged_in?(session)
    !!session[:user_id]
  end

end
