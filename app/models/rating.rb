class Rating < ActiveRecord::Base
    belongs_to :place
    validates :place_id, :score, :ip, presence: true
end
