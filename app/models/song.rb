class Song < ActiveRecord::Base
    attr_accessor :is_new
    belongs_to :artist
    has_many :song_genres
    has_many :genres, through: :song_genres
    include Slugifiable::InstanceMethods
    extend Slugifiable::ClassMethods
end