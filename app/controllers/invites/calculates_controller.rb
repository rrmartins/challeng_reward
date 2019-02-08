module Invites
  class CalculatesController < ApplicationController
    def update
      if calculate_call[:errors].nil?
        render json: @calculate_call[:calculated].to_json, status: :ok
      else
        render json: { errors: @calculate_call[:errors].to_json }, status: :unprocessable_entity
      end
    end

    private

    def calculate_call
      @calculate_call ||= InvitesService::Calculate.call(file)
    end

    def file
      params[:file]
    end
  end
end
