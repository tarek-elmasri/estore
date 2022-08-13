class Interfaces::Items::ItemUpdate 
  include StaffTracker::Recorder

  attr_reader :item

  def initialize item
    self.item = item
  end

  def update! params
    check_authorization
    item.assign_attributes(params.except(:type_name))
    set_discount_state 
    Item.transaction do
      item.save!
      Item::ItemStocker.new(self.item).update_item_stock!
      create_discount_jobs
    end

    staff_recorder()

    return self.item.reload
  end

  def update_discount_status! status
    item.update!(has_discount: status)
  end

  def data_for_image_upload(filename: , checksum: , byte_size: , content_type: )
    check_authorization()

    PresignedUploader::Service.new(
      field_name: :image,
      record_id: item.id,
      record_type: :item,
      filename: filename,
      checksum: checksum,
      byte_size: byte_size,
      content_type: content_type
    ).service_data

  end

  def update_image!(signed_id)

    check_authorization()

    self.item = PresignedUploader::Service::RecordUpdate.new(
      record: item,
      field_name: :image,
      signed_id: signed_id
    ).call
    
    staff_recorder()
    return item

  end

  private
  attr_writer :item

  def staff_recorder
    record(
      :update,
      "item",
      self.item.id
    )
  end

  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_update_item?
  end

  def set_discount_state
    return unless has_discount_dates?
    item.has_discount = should_activate_discount?
  end

  def create_discount_jobs
    return unless has_discount_dates?

    DiscountActivatorJob
                .set(wait_until: item.discount_start_date)
                .perform_later(item.id, :activate) unless item.has_discount?
    
    DiscountActivatorJob
                .set(wait_until: item.discount_end_date)
                .perform_later(item.id, :deactivate) if item.discount_end_date_previously_changed? 
  end

  # def discount_dates_previously_changed?
  #   item.discount_start_date_previously_changed? || item.discount_end_date_previously_changed?
  # end
  
  def has_discount_dates?
    item.discount_start_date? && item.discount_end_date?
  end
  
  def should_activate_discount?
    return false unless has_discount_dates?

    item.discount_start_date < DateTime.now && item.discount_end_date > DateTime.now
  end

end