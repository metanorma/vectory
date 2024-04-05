require "nokogiri"

module Vectory
  class SvgDocument
    SVG_NS = "http://www.w3.org/2000/svg".freeze

    def initialize(content)
      @document = Nokogiri::XML(content)
    end

    def content
      @document.root.to_xml
    end

    def namespace(suffix, links, xpath_to_remove)
      remap_links(links)
      suffix_ids(suffix)
      remove_xpath(xpath_to_remove)
    end

    def remap_links(map)
      @document.xpath(".//m:a", "m" => SVG_NS).each do |a|
        href_attrs = ["xlink:href", "href"]
        href_attrs.each do |p|
          a[p] and x = map[File.expand_path(a[p])] and a[p] = x
        end
      end

      self
    end

    def suffix_ids(suffix)
      ids = collect_ids
      return if ids.empty?

      update_ids_attrs(ids, suffix)
      update_ids_css(ids, suffix)

      self
    end

    def remove_xpath(xpath)
      @document.xpath(xpath).remove

      self
    end

    private

    def collect_ids
      @document.xpath("./@id | .//@id").map(&:value)
    end

    def update_ids_attrs(ids, suffix)
      @document.xpath(". | .//*[@*]").each do |a|
        a.attribute_nodes.each do |x|
          ids.include?(x.value) and x.value += sprintf("_%09d", suffix)
        end
      end
    end

    def update_ids_css(ids, suffix)
      @document.xpath("//m:style", "m" => SVG_NS).each do |s|
        c = s.children.to_xml
        ids.each do |i|
          c = c.gsub(%r[##{i}\b],
                     sprintf("#%<id>s_%<suffix>09d", id: i, suffix: suffix))
            .gsub(%r(\[id\s*=\s*['"]?#{i}['"]?\]),
                  sprintf("[id='%<id>s_%<suffix>09d']", id: i, suffix: suffix))
        end

        s.children = c
      end
    end
  end
end
