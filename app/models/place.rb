class Place < ActiveRecord::Base
    has_many :ratings
    validates :category, :latitude, :longitude, :placename, :address, :website, presence: true
end
