class TimezoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if ActiveSupport::TimeZone[value]

    record.errors.add(attribute, options[:message] || :invalid_format)
  end
end
