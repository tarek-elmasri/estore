class BlobsCleanupJob < ApplicationJob
  queue_as :default

  def perform(blob_id)
    blob = ActiveStorage::Blob.find_by(id: blob_id)
    return unless blob

    attachment = ActiveStorage::Attachment.find_by(blob_id: blob_id)
    return if attachment

    blob.destroy
  end
end
