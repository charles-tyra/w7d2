class User < ApplicationRecord
    validates :email, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: {minimum: 6}, allow_nil: true

    before_validation :ensure_session_token
    attr_reader :password
    def self.find_by_credentials(email, password)
        @user = User.find_by(email: email)
        return @user if @user && @user.is_password?(password)
        return nil
    end

    def is_password?(pass)
        # temp_digetst = BCrypt::Password.new(password_digest)
        # password_digest.is_password?(temp_digetst)
        real_pass = BCrypt::Password.new(password_digest)
        real_pass.is_password?(pass)
    end

    def password=(new_pass)
        @password = new_pass
        self.password_digest = BCrypt::Password.create(new_pass)
    end

    def ensure_session_token
        self.session_token ||= generate_session_token
    end

    def reset_session_token!
       self.session_token = generate_session_token
       self.save!
       self.session_token
    end


    private
    def generate_session_token
        loop do
            session_token = SecureRandom::urlsafe_base64
            return session_token unless User.exists?(session_token: session_token)
        end
    end

end
