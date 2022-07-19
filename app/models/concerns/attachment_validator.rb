class AttachmentValidator < ActiveModel::Validator


  def validate(record)
    record.errors.add(:validator, options.to_s) if options
  end

end