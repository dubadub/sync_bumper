
require 'digest/sha1'
require 'net/http'
require 'net/https'

require 'sync_bumper/model'

module SyncBumper

  class << self
    attr_accessor :url

    def configure(&blk); class_eval(&blk); end

  end
end


if defined? Rails
  # path = Rails.root.join("config/sync_bumper.yml")
  # SyncBumper.load_config(path, Rails.env) if path.exist?

  ActiveRecord::Base.send :extend, SyncBumper::Model::ClassMethods
end
