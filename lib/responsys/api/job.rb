module Responsys
  module Api
    module Job

      def run_job(job_id)
        message = {
          jobId: job_id
        }
        api_method(:run_job, message)
      end

      def get_jobs
        api_method(:get_jobs)
      end

      def get_job_run_log(job_run_id)
        message = {
          jobRunId: job_run_id
        }
        api_method(:get_job_run_log, message)
      end

      def get_job_runs(job_id, start_date, end_date)
        raise ParameterException.new("api.job.incorrect_start_date_type") unless start_date.is_a? DateTime
        raise ParameterException.new("api.job.incorrect_end_date_type") unless end_date.is_a? DateTime
        
        message = {
          jobId: job_id,
          startDate: start_date,
          endDate: end_date
        }
        api_method(:get_job_runs, message)
      end

      def get_job_run_status(job_run_id)
        message = {
          job_run_id: job_run_id
        }
        api_method(:get_job_run_status, message)
      end
    end
  end
end
