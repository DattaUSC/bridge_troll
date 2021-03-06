require 'csv'

module Events
  class StudentsController < ApplicationController
    before_filter :authenticate_user!, :validate_organizer!

    def index
      @event = Event.find(params[:event_id])
      @students = @event.student_rsvps
      respond_to do |format|
        format.csv { send_data student_csv_data(@students), type: :csv }
        format.html {}
      end
    end

    private

    def student_csv_data(rsvps)
      CSV.generate do |csv|
        csv << [
          'Student Name', 'Class Level', 'Operating System', 'Occupation', 'Gender'
        ]

        rsvps.each do |rsvp|
          csv << [
            rsvp.user.full_name, rsvp.class_level, rsvp.operating_system.name,
            rsvp.job_details, rsvp.user.gender
          ]
        end
      end
    end
  end
end
