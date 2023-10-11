require "open3"

module Vectory
  class SystemCall
    attr_reader :status, :stdout, :stderr, :cmd

    def initialize(cmd)
      @cmd = cmd
    end

    def call
      log_cmd(@cmd)

      execute(@cmd)

      log_result

      raise_error unless @status.success?

      self
    end

    private

    def log_cmd(cmd)
      Vectory.ui.debug("Cmd: '#{cmd}'")
    end

    def execute(cmd)
      @stdout, @stderr, @status = Open3.capture3(cmd)
    rescue Errno::ENOENT => e
      raise SystemCallError, e.inspect
    end

    def log_result
      Vectory.ui.debug("Status: #{@status.inspect}")
      Vectory.ui.debug("Stdout: '#{@stdout.strip}'")
      Vectory.ui.debug("Stderr: '#{@stderr.strip}'")
    end

    def raise_error
      raise SystemCallError,
            "Failed to run #{@cmd},\n  " \
            "status: #{@status.exitstatus},\n  " \
            "stdout: '#{@stdout.strip}',\n  " \
            "stderr: '#{@stderr.strip}'"
    end
  end
end
