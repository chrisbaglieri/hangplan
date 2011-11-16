class Facebook < Identity
  validates_inclusion_of :source, :in => %w( facebook )
  
  def initialize(attributes=nil)
    super(attributes)
    self.source = "facebook"
  end
  
  def profile
    @profile ||= FbGraph::User.me(self.access_token).fetch
  end
  
  class << self
    extend ActiveSupport::Memoizable

    def config
      @config ||= if ENV['fb_client_id'] && ENV['fb_client_secret'] && ENV['fb_scope'] && ENV['fb_canvas_url']
        {
          :client_id     => ENV['fb_client_id'],
          :client_secret => ENV['fb_client_secret'],
          :scope         => ENV['fb_scope'],
          :canvas_url    => ENV['fb_canvas_url']
        }
      else
        YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env].symbolize_keys
      end
    rescue Errno::ENOENT => e
      raise StandardError.new("config/facebook.yml could not be loaded.")
    end

    def authenticate(redirect_uri = nil)
      FbGraph::Auth.new config[:client_id], config[:client_secret], :redirect_uri => redirect_uri
    end
    
    def find_or_create_user(fb_user)
      user = User.where(:email => fb_user.email).first
      unless user
        user = User.new
        user.name = [fb_user.firstname, fb_user.lastname].reject(&:empty?).join(' ')
        user.email = fb_user.email
        user.location = fb_user.location
        user.password = (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
        user.password_confirmation = user.password
        user.save
      end
      user
    end
    
  end
end