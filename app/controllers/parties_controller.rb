class PartiesController < ApplicationController
  def index
    @parties = Party.order(sort_column + " " + sort_order).all
  end

  def new
    @party = Party.new
    # # so the view shows 0 and not blank
    # @party.numgsts = 0
  end

  def create
    @party = Party.new(party_params)
    @party.clean_up_guestnames

    if @party.save
      flash[:success] = "Party was saved succesfully!"
      redirect_to parties_url
    else
      flash[:notice]="Party was incorrect."
      redirect_to new_party_url
    end
  end

  private

  def party_params
    params.require(:party).permit(:host_name, :host_email, :numgsts, :guest_names,
                                 :venue, :location, :theme, :start_time, :end_time,
                                 :descript)
  end

  def sort_column
    Party.column_names.include?(params[:sort]) ? params[:sort] : "host_name"
  end

  def sort_order
    %w[asc desc].include?(params[:order]) ? params[:order] : "asc"
  end
end
