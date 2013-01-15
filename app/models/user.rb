class User < ActiveRecord::Base

  include IndexedModel

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  attr_accessible :bugzilla_email, :bugzilla_password

  before_save :encrypt
  after_save :decrypt

  has_many :async_job

  index_options :extended_json=>:extended_index_attrs,
                :json=>{:only=> [:email]},
                :display_attrs => [:email]

  def extended_index_attrs
    {}
  end

  # TODO: add user preference for page size
  def page_size
    25
  end

  private

  # From http://philtoland.com/post/807114394/simple-blowfish-encryption-with-ruby
  def cipher(mode, key, data)
    cipher = OpenSSL::Cipher::Cipher.new('bf-cbc').send(mode)
    cipher.key = Digest::SHA256.digest(key)
    cipher.update(data) << cipher.final
  end

  def encrypt
    @bugzilla_password = cipher(:encrypt, AppConfig.encrypt_key, @bugzilla_password) unless @bugzilla_password.nil?
  end

  def decrypt
    @bugzilla_password = cipher(:decrypt, AppConfig.encrypt_key, @bugzilla_password) unless @bugzilla_password.nil?
  end
end
