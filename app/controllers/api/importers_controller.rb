class Api::ImportersController < Api::BaseController
  def restaurant
    uploaded_file = restaurant_params[:json_file]

    if uploaded_file.nil?
      return render_bad_request("No file uploaded")
    end

    importer = Importer::Restaurant.new(file: uploaded_file).run

    render_success(importer)
  rescue JSON::ParserError => e
    render_bad_request("Invalid JSON format: #{e.message}")
  rescue ActiveRecord::RecordInvalid => e
    render_validation_error(e.record)
  rescue => e
    handle_server_error(e)
  end

  private

  def restaurant_params
    params.permit(:json_file)
  end

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
