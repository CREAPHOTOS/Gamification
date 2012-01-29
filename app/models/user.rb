require 'typus/orm/active_record/user/instance_methods'
require 'typus/orm/active_record/user/instance_methods_more'

class User < ActiveRecord::Base
  before_create :default_values

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :f_name, :l_name, :username, :website

  #attr_accessible :email, :password, :password_confirmation, :remember_me, :f_name, :l_name, :username, :website, :as => :admin

  include Typus::Orm::ActiveRecord::User::InstanceMethods
  include Typus::Orm::ActiveRecord::User::InstanceMethodsMore
  
  has_many :comments

  has_many :entr_mission_users
  has_many :missions, :through => :entr_mission_users

  has_one :user_ressource


  # Typus
  def to_label
    "#{self.f_name} #{self.l_name}"
  end

  alias :to_s :to_label

  def missions_applied
    self.entr_mission_users.where(:state => EntrMissionUser::Status::APPLIED).count
  end

  def missions_todo
    self.entr_mission_users.where(:state => EntrMissionUser::Status::CONFIRMED).count
  end

  def missions_done
    self.entr_mission_users.where(:state => EntrMissionUser::Status::DONE).count
  end

  def missions_refused
    self.entr_mission_users.where(:state => EntrMissionUser::Status::CANCELED).count
  end

  
  # Some validations
  validates_uniqueness_of :username

  # Some Methods
  def has_link_with_mission mission_id
    entr = EntrMissionUser.where("user_id = ? AND mission_id = ?", self.id, mission_id)
    if entr.empty?
      return false
    end
    return true
  end

  def is_admin?
    self.admin || false
  end


  # def todo_mission
    
  #   Mission
  #     .includes(:entr_mission_users)
  #     .where('entr_mission_users.user_id = ? AND entr_mission_users.state = ?', 
  #            self.id, EntrMissionUser::Status::CONFIRMED)
    
  # end

# scope :user_todo_missions, lambda { |user|
#     includes(:entr_mission_users)
#       .order('begin_date ASC')
#       .where('missions.id in (?) AND entr_mission_users.state = ?', user.missions.map(&:id), EntrMissionUser::STATES[1][1])
#   }

  

  protected  
  def default_values
    self.cash = 0
    self.epices = 0
    self.points = 20
  end
end