require "open3"

module Vectory
  class SystemCall
    def initialize(cmd)
      @cmd = cmd
    end

    def call
      log_cmd(@cmd)

      stdout, stderr, status = execute(@cmd)

      log_result(status, stdout, stderr)

      raise_error(cmd, status, stdout, stderr) unless status.success?
    end

    private

    def log_cmd(cmd)
      Vectory.ui.debug("Cmd: '#{cmd}'")
    end

    def execute(cmd)
      Open3.capture3(cmd)
    rescue Errno::ENOENT => e
      raise BinaryCallError, e.inspect
    end

    def log_result(status, stdout, stderr)
      Vectory.ui.debug("Status: #{status.inspect}")
      Vectory.ui.debug("Stdout: '#{stdout.strip}'")
      Vectory.ui.debug("Stderr: '#{stderr.strip}'")
    end

    def raise_error(cmd, status, stdout, stderr)
      raise BinaryCallError,
            "Failed to run #{cmd},\n  " \
            "status: #{status.exitstatus},\n  " \
            "stdout: '#{stdout.strip}',\n  " \
            "stderr: '#{stderr.strip}'"
    end
  end
end
