require 'htmlentities'
require 'nokogiri'
require "tmpdir"

module Vectory
  module Helper
    def spec_dir(&block)
      Dir.mktmpdir(nil, Vectory.root_path.join("tmp/"), &block)
    end

    def xmlpp(xml)
      c = HTMLEntities.new
      xml &&= xml.split(/(&\S+?;)/).map do |n|
        if /^&\S+?;$/.match?(n)
          c.encode(c.decode(n), :hexadecimal)
        else n
        end
      end.join
      xsl = <<~XSL
        <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
          <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
          <!--<xsl:strip-space elements="*"/>-->
          <xsl:template match="/">
            <xsl:copy-of select="."/>
          </xsl:template>
        </xsl:stylesheet>
      XSL
      Nokogiri::XSLT(xsl).transform(Nokogiri::XML(xml, &:noblanks))
        .to_xml(indent: 2, encoding: "UTF-8")
    end

    def strip_guid(xml)
      xml.gsub(%r{ id="_[^"]+"}, ' id="_"')
        .gsub(%r{ target="_[^"]+"}, ' target="_"')
        .gsub(%r( href="#[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}"), ' href="#_"')
        .gsub(%r( id="[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}"), ' id="_"')
        .gsub(%r( id="ftn[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}"), ' id="ftn_"')
        .gsub(%r( id="fn:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}"), ' id="fn:_"')
        .gsub(%r( reference="[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"), ' reference="_"')
        .gsub(%r[ src="([^/]+)/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.], ' src="\\1/_.')
    end
  end
end
