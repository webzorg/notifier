class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value.is_a?(Date)

    if options[:today_or_future] && value && value < Date.today
      record.errors.add(attribute, options[:message] || :must_be_today_or_in_future)
    end
  rescue ArgumentError
    record.errors.add(attribute, options[:message] || :is_not_a_valid_date)
  end
end
