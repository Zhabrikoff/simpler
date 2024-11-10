require "logger"

class SimplerLogger
  def initialize(app)
    @app = app
    @logger = Logger.new(Simpler.root.join("log/app.log"), "daily")
    @logger.level = Logger::INFO

    @logger.formatter = proc do |severity, datetime, progname, msg|
      time_str = datetime.strftime("%Y-%m-%d %H:%M:%S")
      "[#{time_str}] #{severity}:\n#{msg}\n"
    end
  end

  def call(env)
    @env = env
    status, headers, body = @app.call(@env)

    log_request(status, headers)

    [status, headers, body]
  end

  private

  def log_request(status, headers)
    log_message = StringIO.new
    log_message.puts "  Request: #{@env["REQUEST_METHOD"]} #{@env["REQUEST_URI"]}"
    log_message.puts "  Handler: #{@env["simpler.controller"].class.name}##{@env["simpler.action"]}"
    log_message.puts "  Parameters: #{Rack::Request.new(@env).params}"
    log_message.puts "  Response: #{status} [#{headers["Content-Type"]}] #{@env["simpler.template"]}"
    log_message.puts "-" * 80

    @logger.info(log_message.string)
  end
end
