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
end
