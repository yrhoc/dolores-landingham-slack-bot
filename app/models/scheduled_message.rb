class ScheduledMessage < ActiveRecord::Base
  validates :body, presence: true
  validates :days_after_start, presence: true
  validates :tag_list, presence: true
  validates :time_of_day, presence: true
  validates :title, presence: true

  acts_as_taggable

  def self.filter(params)
    if params[:title].present? || params[:body].present? || params[:tag].present?
      results = self.all.where("lower(title) like ?", "%#{params[:title].downcase}%")
        .where("lower(body) like ?", "%#{params[:body].downcase}%")

      if params[:tag].present?
        tags = params[:tag].split(",").each { |t| t.strip }
        results = results.tagged_with(tags, :any => true)
      end
      results
    else
      self.all
    end
  end
end
