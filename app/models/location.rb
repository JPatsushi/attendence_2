class Location < ApplicationRecord
  validates :lo_number, presence: true, uniqueness: true
  validates :lo_name, presence: true
  validates :lo_type, presence: true
end
