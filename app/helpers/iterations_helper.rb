module IterationsHelper
  def format_date(dt)
    dt.nil? ? 'Not Given' : dt.to_formatted_s(:db)
  end
end