if Rails.env.production?
  Delayed::Worker.destroy_failed_jobs = false
  Delayed::Worker.sleep_delay = 2
  Delayed::Worker.max_attempts = 10
  Delayed::Worker.max_run_time = 48.hours
  Delayed::Worker.delay_jobs = !Rails.env.test?
end
