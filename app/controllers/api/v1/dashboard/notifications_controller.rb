class Api::V1::Dashboard::NotificationsController < Api::V1::Dashboard::Base
  include Scopes::Dashboard::NotificationsScopes

  before_action :set_notification, only: [:update]

  apply_controller_scopes only: [:index]

  def index
    notifications = apply_scopes(Notification.order_by_recent.page(1))
    respond({
      notifications: serialize_resource(
        notifications,
        each_serializer: Dashboard::NotificationSerializer
      ),
      pagination_details: pagination_details(notifications)
    })
  end

  def update
    @notification.update!(notifications_params)
    respond(
      serialize_resource(
        @notification,
        serializer: Dashboard::NotificationSerializer
      ).to_json
    )
  end

  private
  def notifications_params
    params.require(:notification).permit(:seen)
  end

  def set_notification
    @notification = Notification.find(params.require(:id))
  end


end