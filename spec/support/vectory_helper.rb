require "htmlentities"
require "nokogiri"
require "tmpdir"

module Vectory
  module Helper
    def with_tmp_dir(&block)
      Dir.mktmpdir(nil, Vectory.root_path.join("tmp/"), &block)
    end
  end
end
