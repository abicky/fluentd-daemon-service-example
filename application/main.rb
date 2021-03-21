require 'logger'

$stdout.sync = true
logger = Logger.new($stdout)

msg = "0123456789" * 10

logger.info "Started"
180_000.times do |i|
  logger.info "#{i}: #{msg}"
  sleep 0.001
end
logger.info "Finished"
