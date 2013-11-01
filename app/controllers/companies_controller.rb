class CompaniesController < ApplicationController


  def update
    if request.xhr?
      render :text => params[:company].values.first
    end
  end

end