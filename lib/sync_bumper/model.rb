module SyncBumper
  module Model

    def self.enabled?
      Thread.current["model_sync_enabled"]
    end

    def self.context
      Thread.current["model_sync_context"]
    end

    def self.enable!(context = nil)
      Thread.current["model_sync_enabled"] = true
      Thread.current["model_sync_context"] = context
    end

    def self.disable!
      Thread.current["model_sync_enabled"] = false
      Thread.current["model_sync_context"] = nil
    end

    def self.enable(context = nil)
      enable!(context)
      yield
    ensure
      disable!
    end

    module ClassMethods
      attr_accessor :sync_scope

      def sync(*actions)
        include ModelActions
        if actions.last.is_a? Hash
          @sync_scope = actions.last.fetch :scope
        end
        actions = [:create, :update, :destroy] if actions.include? :all
        actions.flatten!

        if actions.include? :create
          after_create :publish_sync_create, :on => :create#, :if => lamda { Sync::Model.enabled? }
        end
        if actions.include? :update
          after_update :publish_sync_update, :on => :update#, :if => lamda { Sync::Model.enabled? }
        end
        if actions.include? :destroy
          after_destroy :publish_sync_destroy, :on => :destroy#, :if => lamda { Sync::Model.enabled? }
        end
      end
    end

    module ModelActions
      def sync_scope
        return nil unless self.class.sync_scope
        send self.class.sync_scope
      end

      def publish_sync_create
        Thread.new do
          uri = URI(SyncBumper.url.call(id))
          req = Net::HTTP::Post.new(uri.request_uri)

          perform_request(req, uri)
        end
      end

      def publish_sync_update
        Thread.new do
          uri = URI(SyncBumper.url.call(id))
          req = Net::HTTP::Put.new(uri.request_uri)

          perform_request(req, uri)
        end
      end

      def publish_sync_destroy
        Thread.new do
          uri = URI(SyncBumper.url.call(id))
          req = Net::HTTP::Delete.new(uri.request_uri)

          perform_request(req, uri)
        end
      end

      def perform_request(req, uri)
        req["Content-Type"] = 'text/plain;charset=UTF-8'
        req["Content-Length"] = '0'

        res = Net::HTTP.start(uri.host, uri.port) { |http| http.request(req) }
      end
    end
  end
end
