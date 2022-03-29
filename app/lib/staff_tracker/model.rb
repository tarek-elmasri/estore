module StaffTracker
  module Model
    extend ActiveSupport::Concern

    included do
      after_create :record_create
      after_update :record_update
      after_destroy :record_destroy

      private
      def record_create
        recorder(:create)
      end

      def record_update
        recorder(:update)
      end

      def record_destroy
        recorder(:delete)
      end
      
      def recorder(action)
        return unless Current.user.is_staff? || Current.user.is_admin?
        Current.user.staff_actions.new(action: action , model: self.class.to_s.downcase, model_id: self.id).save
      end
    end
  end
end