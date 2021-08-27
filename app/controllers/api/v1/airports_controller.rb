module API
  module V1
    class AirportsController < BaseController
      def index
        records =
          paginate Airport.by_countries(index_params[:countries])
                          .by_capacity_descending

        render json: AirportSerializer.render(records)
      end

      private

      def index_params
        params.permit(countries: [])
      end
    end
  end
end
