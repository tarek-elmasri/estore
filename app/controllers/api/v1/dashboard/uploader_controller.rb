class Api::V1::Dashboard::UploaderController < Api::V1::Dashboard::Base


  def create
    uploader = PresignedUploader::Service.new(
      field_name: params.require(:field_name),
      record_id: params.require(:record_id),
      record_type: params.require(:record_type),
      filename: params.require(:filename),
      checksum: params.require(:checksum),
      byte_size: params.require(:byte_size),
      content_type: params.require(:content_type)
    )

    respond({data: uploader.service_data})
  end

end