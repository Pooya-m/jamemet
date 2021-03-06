require 'sitemap_pinger'

class Poem < ActiveRecord::Base
  #call_backs:
  before_create :create_poet
  before_update :create_poet

  belongs_to :poet
  belongs_to :user

  validates_presence_of :content
  validates_presence_of :poet_name
  validates_length_of :content, maximum: 120

  has_many :votes , dependent: :destroy

  def create_poet
    @poet = Poet.find_or_initialize_by_poet_name(self.poet_name)
    @poet.save!
    self.poet_id = @poet.id
  end

  def ping
    SitemapPinger.ping
  end

  def self.get_weekly_poems
    self.where('created_at >= ?', 1.week.ago)
  end

end
