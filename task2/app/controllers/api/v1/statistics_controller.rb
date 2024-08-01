class Api::V1::StatisticsController < ApplicationController
  def index
    render json: {
      user_count: User.count,
      artist_count: Artist.count,
      song_count: Song.count
    }
  end
end
