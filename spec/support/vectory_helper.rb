require "htmlentities"
require "nokogiri"
require "tmpdir"

module Vectory
  module Helper
    def with_tmp_dir(&block)
      Dir.mktmpdir(nil, Vectory.root_path.join("tmp/"), &block)
    end

    def in_tmp_dir(&block)
      Dir.mktmpdir(nil, Vectory.root_path.join("tmp/")) do |dir|
        Dir.chdir(dir, &block)
      end
    end

    def xmlpp(xml)
      xsl = <<~XSL
        <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
          <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
          <xsl:strip-space elements="*"/>
          <xsl:template match="/">
            <xsl:copy-of select="."/>
          </xsl:template>
        </xsl:stylesheet>
      XSL
      Nokogiri::XSLT(xsl).transform(Nokogiri::XML(xml, &:noblanks))
        .to_xml(indent: 2, encoding: "UTF-8")
    end
  end
end
