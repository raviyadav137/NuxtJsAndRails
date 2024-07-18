class Api::V1::SongsController < ApplicationController
  def index
    @music = Song.all 
    render json: @music 
  end
  
  # GET /api/v1/music/:id
  def show
    music = Song.find_by(id: params[:id])
    if music
      render json: { message: "Music found", data: music }
    else
      render json: { message: "Music not found", data: {} }, status: :not_found
    end
  end

  # POST /api/v1/music
  def create
    @song = Song.new(song_params)

    if @song.save
      render json: @song, status: :created
    else
      render json: { errors: @song.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/music/:id
  def update
    music = Song.find_by(id: params[:id])
    if music && music.update(song_params)
      render json: { message: "Music updated", data: music }
    else
      render json: { message: "Error updating music", data: music ? music.errors : { id: ["not found"] } }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/music/:id
  def destroy
    music = Song.find_by(id: params[:id])
    if music && music.destroy
      render json: { message: "Music deleted", data: music }
    else
      render json: { message: "Error deleting music", data: music ? music.errors : { id: ["not found"] } }, status: :unprocessable_entity
    end
  end

  private

  def song_params
    params.require(:song).permit(:artist_id, :title, :album, :genre, :artist_name)
  end
end
