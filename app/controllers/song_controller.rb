class SongController < ApplicationController
    use Rack::Flash
    
    get '/songs/new' do
        @artists = Artist.all
        @genres = Genre.all
        erb :'songs/new'
    end

    post '/songs' do
        @song = Song.create(name: params["song"]["name"])
        if params["song"]["new_artist"].empty?
            artist = Artist.find(params["artists"].first)
            artist.songs << @song
        else
            if Artist.find_by_name(params["song"]["new_artist"])
                new_artist = Artist.find_by_name(params["song"]["new_artist"])
            else
                new_artist = Artist.create(name: params["song"]["new_artist"])
            end
            new_artist.songs << @song
        end
        if params["song"]["new_genre"].empty?
            genre = Genre.find(params["genres"].first)
            genre.songs << @song
        else
            new_genre = Genre.create(name: params["song"]["new_genre"])
            new_genre.songs << @song
        end
        flash[:message] = "Successfully created song."
        redirect "/songs/#{@song.slug}"
    end
    
    get '/songs' do
        @songs = Song.all
        erb :'songs/index'
    end

    get '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        erb :'songs/show'
    end

    get '/songs/:slug/edit' do
        @song = Song.find_by_slug(params[:slug])
        @artists = Artist.all
        @genres = Genre.all
        erb :'songs/edit'
    end

    patch '/songs/:slug' do
        @song = Song.find_by_name(params[:song][:name])
        if params[:genres]
            @song.genres = Genre.find(params[:genres])
        end
        if params[:song][:new_artist] != ""
            new_artist = Artist.find_or_create_by(name: params[:song][:new_artist])
            new_artist.songs << @song
        else
            new_artist = Artist.find(params[:artists])
            new_artist.songs << @song
            binding.pry
        end
        flash[:message] = "Successfully updated song."        
        redirect "/songs/#{@song.slug}"
    end

end


