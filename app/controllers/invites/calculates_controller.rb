module Invites
  class CalculatesController < ApplicationController
    def update
      if calculate_call
        render status: :ok, json: @calculate_call.calc_result
      else
        render status: :unprocessable_entity, json: { errors: @calculate_call.errors }
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
