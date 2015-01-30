require "capybara"
require "capybara/dsl"

require_relative "angular/dsl"
require_relative "angular/waiter"

module Capybara
  module Angular
    def self.default_wait_time
      @default_wait_time || Capybara.default_wait_time
    end

    def self.default_wait_time=(timeout)
      @default_wait_time = timeout
    end

    def self.app_selector
      @app_selector || "[ng-app], [data-ng-app]"
    end

    def self.app_selector=(selector)
      if selector == 'document'
        @app_selector = selector
      else
        @app_selector = "document.querySelector('#{selector}')"
      end
    end

    def self.app_exists_selector
      @app_exists_selector || "[ng-app], [data-ng-app]"
    end

    def self.app_exists_selector=(selector)
      if selector == 'document'
        @app_exists_selector = selector
      else
        @app_exists_selector = "document.querySelector('#{selector}')"
      end
    end
  end
end
