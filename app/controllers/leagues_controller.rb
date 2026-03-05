class LeaguesController < ApplicationController
  before_action :set_league, only: %i[ show edit update destroy ]

  # GET /leagues or /leagues.json
  def index
    @leagues = League.all
  end

  # GET /leagues/1 or /leagues/1.json
  def show
  end

  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit
  end

  # POST /leagues or /leagues.json
  def create
    @league = League.new(league_params.merge(user_id: Current.session.user.id))

    respond_to do |format|
      if @league.save
        session[:current_league_id] = @league.id
        format.html { redirect_to draft_board_index_path, notice: "League was successfully created." }
        format.json { render :show, status: :created, location: @league }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leagues/1 or /leagues/1.json
  def update
    respond_to do |format|
      if @league.update(league_params)
        format.html { redirect_to @league, notice: "League was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @league }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1 or /leagues/1.json
  def destroy
    @league.destroy!

    respond_to do |format|
      format.html { redirect_to leagues_path, notice: "League was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league
      @league = League.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def league_params
      params.expect(league: [ :name, :scoring_format, :platform, { roster_slots: {} } ])
    end
end
