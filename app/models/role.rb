# == Schema Information
#
# Table name: roles
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  resource_type    :string(255)
#  resource_id      :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  translation_name :string(255)
#  icon             :string(255)
#
class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles
  has_and_belongs_to_many :states, :join_table => :roles_states
  
  belongs_to :resource,
             :polymorphic => true,
             :optional => true
  

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
end
