module Capybara
  module Angular
    class Waiter
      attr_accessor :page

      def initialize(page)
        @page = page
      end

      def wait_until_ready
        return unless angular_app?

        setup_ready

        start = Time.now
        until ready?
          timeout! if timeout?(start)
          if page_reloaded_on_wait?
            return unless angular_app?
            setup_ready
          end
          sleep(0.01)
        end
      end

      private

      def timeout?(start)
        Time.now - start > Capybara::Angular.default_wait_time
      end

      def timeout!
        raise TimeoutError.new("timeout while waiting for angular")
      end

      def ready?
        page.evaluate_script("window.angularReady")
      end

      def angular_app?
        js = "(typeof angular !== 'undefined') && "
        js += "angular.element(document.querySelector('[ng-app], [data-ng-app], .ng-scope')).length > 0"
        page.evaluate_script js

      rescue Capybara::NotSupportedByDriverError
        false
      end

      def setup_ready
        page.execute_script <<-JS
          angular.element(document).ready(function() {
            var app = angular.element(document.querySelector('[ng-app], [data-ng-app]'));
            var injector = app.injector();
            injector.invoke(function($browser) {
              if ($browser.outstandingRequestCount > 0) {
                window.angularReady = false;
              }
              $browser.notifyWhenNoOutstandingRequests(function() {
                window.angularReady = true;
              });
            });
          });
        JS
      end

      def page_reloaded_on_wait?
        page.evaluate_script("window.angularReady === undefined")
      end
    end
  end
end
