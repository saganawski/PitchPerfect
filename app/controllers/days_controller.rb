class DaysController < ApplicationController
	before_action :require_login

  def new
		redirect_to days_path unless admin?
	end

  def index
    @days = Day.all
  end

  def show
    @users = User.all
    @pitch = Pitch.new()
    @day = Day.find_by(id: params[:id])
    @pitches = Pitch.all.where(day_id: @day.id)
  end

  def create
  	redirect_to days_path unless admin?

  	day = Day.new(days_params)
  	if day.save
  		redirect_to days_path
  	else
  		@errors = day.errors.full_messages
  		render new_day_path
  	end
  end

  def update
  	day = Day.find_by(id: params[:id])

  	day.round_status = advance_to_next_round(day)
  	day.save
    if day.round_status == 'closed'
      @users = User.all
      p "---------------------------------------------"
      p @users
      @pitches = day.pitches
      render teams_new_path
    else
      redirect_to days_path
    end
  end

  private
	def days_params
		params.require(:day).permit(:cohort_name, :pic_url, :round_status, :date, :passing_number, :teams_total)
	end

end

