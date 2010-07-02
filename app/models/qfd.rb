class Qfd < ActiveRecord::Base
  include SpreadsheetExport::Qfd

  belongs_to :user

  has_one :hoq_list
  has_many :hoqs, :through => :hoq_list
  has_many :invitations, :dependent => :destroy
  has_many :ro_invitations, :class_name => "Invitation", :conditions => {:read_only => true}
  has_many :rw_invitations, :class_name => "Invitation", :conditions => {:read_only => false}

  has_many :collaborators, :through => :invitations, :source => :recipient

  validates_presence_of :name

  after_create :create_hoq_list

  accepts_nested_attributes_for :invitations, :allow_destroy => true

  named_scope :public, :conditions => ["public IS ?", true]
end
