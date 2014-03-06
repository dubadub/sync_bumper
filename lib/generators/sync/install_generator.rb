module SyncBumper
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end

      def copy_files
        template "sync_bumper.rb", "config/initializers/sync_bumper.rb"
      end
    end
  end
end
