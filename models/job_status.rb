class JobStatus < Settingslogic
  source 'config/job_status.yml'
  namespace 'status'
  load!
end
