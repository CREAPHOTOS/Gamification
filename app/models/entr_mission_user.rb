class EntrMissionUser < ActiveRecord::Base
  belongs_to :mission
  belongs_to :user
end
