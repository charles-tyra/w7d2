class User < ApplicationRecord
    validates :email, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: {minimum: 6}, allow_nil: true

    before_validations :ensure_session_token
    attr_reader :password
    def self.find_by_credentials(email, password)
    end

    def is_password(pass)
        # temp_digetst = BCrypt::Password.new(password_digest)
        # password_digest.is_password?(temp_digetst)
        real_pass = BCrypt::Password.new(password_digest)
        real_pass.is_password?(pass)
    end

    def password=(new_pass)
        password = new_pass
        password_digest = BCrypt::Password.create(new_pass)
    end

    def ensure_session_token
        session_token ||= generate_session_token
    end

    def reset_session_token!
        session_token = generate_session_token
    end


    private
    def generate_session_token
        loop do
            session_token = SecureRandom::base_64
            return session_token if !session[session_token]
        end
    end

end
