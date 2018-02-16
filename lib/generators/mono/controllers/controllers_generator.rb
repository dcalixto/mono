require 'rails/generators/base'

module Mono
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      CONTROLLERS = %w(passwords users sessions).freeze

      source_root File.expand_path('../templates', __FILE__)



      def create_controllers

        controllers = options[:controllers] || CONTROLLERS
        controllers.each do |name|
          template "#{name}_controller.rb",
            "app/controllers/#{name}_controller.rb"
        end
      end


    end
  end
end