# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  phone                  :string(255)
#  username               :string(255)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  sign_in_count          :integer          default(0)
#  token                  :text(65535)
#
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :timeoutable, :authentication_keys => [:login]

  attr_accessor :login
  cattr_accessor :current_user
  has_many :my_downloads
  has_many :export_excel_cells_users
  has_many :export_excel_cells, through: :export_excel_cells_users
  has_many :history_by_batches

  after_create :init_role

  has_one_attached :avatar

  def init_role
    self.add_role :visitor if self.roles.empty?
  end

  def department_roles
    self.roles.where.not(name: ['manage','execute'])
  end

  def has_role_states
    State.where(id: self.roles.select{|role|role.name=='manage' and role.resource_type=='State'}.map(&:resource_id)) rescue []
  end

  def has_role_sites
    Site.where(id: self.roles.select{|role|role.name=='manage' and role.resource_type=='Site'}.map(&:resource_id)) rescue []
  end

  # Confirm user has role? If true then return, if fasle then add relation
  def confirm_exist_and_add_role(type, resource)
    self.has_role?(type, resource) ? return : self.add_role(type, resource)
  end

  # Confirm user has role? If true then remove, if fasle then return
  def confirm_exist_and_remove_role(type, resource)
    self.has_role?(type, resource) ? self.remove_role(type, resource) : return
  end

  def avatar_attachment_path
    avatar.attached? ? avatar.service_url : '/img/avatars/profiles/avatar-1.jpg'
  end

  protected
  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(phone) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
  end
end
