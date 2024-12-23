module DueDateReminder
  class DispatcherJob < ApplicationJob
    DELIVERY_METHODS = %i[email]

    def perform
      Ticket.includes(:user).active.where(user: { due_date_reminder_enabled: true }).find_each do |ticket|
        schedule_reminders_for(ticket) if due_today?(ticket)
      end
    end

    private

    def due_today?(ticket)
      reminder_date = ticket.due_date - ticket.user.due_date_reminder_offset_in_days.days
      reminder_date == Time.zone.today
    end

    def schedule_reminders_for(ticket)
      ticket.user.reminder_delivery_methods.each do |delivery_method|
        get_class_for(delivery_method).set(wait_until: ticket.expected_reminder_delivery_time).perform_later(ticket.id)
      end
    end

    def get_class_for(delivery_method)
      case delivery_method
      when :email
        EmailJob
      else
        raise NotImplementedError
      end
    end
  end
end
