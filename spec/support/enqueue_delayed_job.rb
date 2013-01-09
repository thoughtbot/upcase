module DelayedJob
  module Matchers
    def enqueue_delayed_job(handler)
      DelayedJobMatcher.new handler
    end

    class DelayedJobMatcher
      def initialize(handler)
        @handler = handler
        @attributes = {}
        @priority = 0
        @failure_message = ''
      end

      def description
        "enqueue a #{@handler} delayed job"
      end

      def failure_message
        @failure_message || <<-message.strip_heredoc
          Expected #{@handler} to be enqueued as a delayed job. Try:
          Delayed::Job.enqueue #{@handler}.new
        message
      end

      def matches?(subject)
        @subject = subject
        enqueued? && correct_attributes? && correct_priority?
      end

      def priority(priority)
        @priority = priority
        self
      end

      def with_attributes(attributes)
        @attributes = attributes
        self
      end

      private

      def correct_attributes?
        @attributes.each do |key, value|
          payload_object.send(key).should == value
        end
      end

      def correct_priority?
        if @priority == job.priority
          true
        else
          @failure_message = <<-message.strip_heredoc
            Expected priority to be #{@priority} but was #{job.priority}"
          message

          false
        end
      end

      def enqueued?
        payload_object.kind_of? @handler.constantize
      end

      def job
        if Delayed::Job.count.zero?
          raise "No jobs in queue"
        else
          Delayed::Job.last
        end
      end

      def payload_object
        job.payload_object
      end
    end
  end
end

RSpec.configure do |c|
  c.include DelayedJob::Matchers
end
