#
# Table Schema
# ------------
# id            - int(11)      - default NULL
# host_name     - varchar(255) - default NULL
# host_email    - varchar(255) - default NULL
# numgsts       - int(11)      - default NULL
# guest_names   - text         - default NULL
# venue         - varchar(255) - default NULL
# location      - varchar(255) - default NULL
# theme         - varchar(255) - default NULL
# start_time    - datetime     - default NULL
# end_time      - datetime     - default NULL
# descript      - text         - default NULL
#
class Party < ApplicationRecord
  before_save :default_values

  validates :host_name, :host_email, :venue, :location, :theme, length: { maximum: 255,
  too_long: "%{count} characters is the maximum allowed" }

  validates :venue, presence: { message: "Where is the party?" }

  validate :incorrect_date_and_time, :missing_guest_names

  def incorrect_date_and_time
    # ruby doesn't like us using when as column name for some reason
    if self.start_time > self.end_time
      errors.add(:base, "Incorrect party time.")
    end
  end

  def missing_guest_names
    if guest_names.split(',').size != numgsts
      errors.add(:guest_names, "Missing guest name")
    end
  end

  def clean_up_guestnames
    # clean "Harry S. Truman" guest name to "Harry S._Truman"
    # clean "Roger      Rabbit" guest name to "Roger Rabbit"
    gnames = []
    self.guest_names.split(',').each do |g|
      g.squeeze!
      names=g.split(' ')
      gnames << "#{names[0]} #{names[1..-1].join('_')}"
    end
    self.guest_names = gnames
  end

  private

  def default_values
    # note end_time = start_time.end_of_day if self.end_time.nil? might be safer
    self.end_time ||= self.start_time.end_of_day
  end

end
