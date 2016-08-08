class Request < ActiveRecord::Base
    validates :category, :placename, :address, :website, presence: true
end
