class Api::BaseController < ActionController::API
  def render_success(importer)
    render json: {
      status: "success"
    }, status: :created
  end

  def render_bad_request(message)
    render json: { error: message }, status: :bad_request
  end

  def render_validation_error(record)
    render json: {
      error: "Validation failed",
      details: record.errors.full_messages
    }, status: :unprocessable_entity
  end

  def handle_server_error(error)
    Rails.logger.error("Import Error: #{error.message}\n#{error.backtrace.first(10).join("\n")}")

    message = if Rails.env.production?
                "Internal server error"
    else
                "#{error.class}: #{error.message}"
    end

    render json: { error: message }, status: :internal_server_error
  end
end
