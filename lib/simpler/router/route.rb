module Simpler
  class Router
    class Route
      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        @method == method && path.match(regexp_path)
      end

      def add_params(path)
        path_params = path.scan(%r{\w+/\d+}).join("/").split("/")
        params[:id] = path_params.last.to_i
      end

      private

      def regexp_path
        Regexp.new("^#{@path.gsub(/:id/, '\d+')}$")
      end
    end
  end
end
