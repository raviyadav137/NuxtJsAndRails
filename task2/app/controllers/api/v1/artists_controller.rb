class Api::V1::ArtistsController < ApplicationController
  def index
    @artists = Artist.all
    render json: @artists
  end

  def show
    artist = Artist.find(params[:id])
    if artist
      render json: { message: 'Artist found', data: artist }
    else
      render json: { message: 'Artist not found', data: nil }
    end
  end

  def create
    artist = Artist.new(artist_params)
    if artist.save
      render json: { message: 'Saved successfully', data: artist }
    else
      render json: { message: 'Error saving artist', data: artist.errors }
    end
  end

  def update
    artist = Artist.find(params[:id])
    if artist.update(artist_params)
      render json: { message: 'Artist updated', data: artist }
    else
      render json: { message: 'Error updating artist', data: artist.errors }
    end
  end

  def destroy
    artist = Artist.find(params[:id])
    artist_id = artist.id
    if artist.destroy
      render json: { message: 'Artist deleted', data: { id: artist_id } }
    else
      render json: { message: 'Error deleting artist', data: artist.errors }
    end
  end

  private

  def artist_params
    params.require(:artist).permit(:name, :dob, :gender, :address, :first_release_year, :no_of_albums_released)
  end
end
