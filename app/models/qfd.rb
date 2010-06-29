class Qfd < ActiveRecord::Base
  include SpreadsheetExport::Qfd

  belongs_to :user

  has_one :hoq_list
  has_many :hoqs, :through => :hoq_list
  has_many :invitations
  has_many :collaborators, :through => :invitations, :source => :recipient

  validates_presence_of :name

  after_create :create_hoq_list

  accepts_nested_attributes_for :invitations, :allow_destroy => true

  named_scope :public, :conditions => ["public IS ?", true]


  def owns_rating?(rating)
    hoqs.any? {|h| h.owns_rating?(rating)}
  end

end
