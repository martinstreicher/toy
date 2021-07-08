class SocialMediaInteractor
  include Interactor
  include Memery

  FACEBOOK_URL = 'https://takehome.io/facebook'
  TWITTER_URL  = 'https://takehome.io/twitter'
  TIMEOUT      = 1

  SERVICES = {
    facebook: FACEBOOK_URL,
    twitter:  TWITTER_URL
  }

  delegate_missing_to :context

  def call
    context.posts = {}
    service :facebook
    service :twitter
    hydra.run
  end

  private

  memoize def hydra
    Typhoeus::Hydra.hydra
  end

  def service(name)
    data    = []
    request = Typhoeus::Request.new SERVICES[name], timeout: TIMEOUT

    request.on_complete do |response|
      if response.success?
        begin
          data = JSON.parse(response.body)
        rescue JSON::ParserError => e
        ensure
          context.posts[name] = data
        end
      end
    end

    hydra.queue request
  end
end
