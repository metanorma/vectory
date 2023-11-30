RSpec::Matchers.define :be_eps do
  match do |actual|
    actual.start_with?("%!PS-Adobe-3.0")
  end
end

RSpec::Matchers.define :be_svg do
  match do |actual|
    actual.include?("<svg")
  end
end

RSpec::Matchers.define :be_equivalent_eps_to do |expected|
  match do |actual|
    e = sub_time_and_version(expected)
    a = sub_time_and_version(actual)

    windows_pattern = /mswin|msys|mingw|cygwin|bccwin|wince|emc/
    if RbConfig::CONFIG["host_os"].match?(windows_pattern)
      Vectory.ui.debug("Using `TextMatcher`.")

      Vectory::TextMatcher.new(allowed_changed_lines: 60,
                               allowed_changed_words_in_line: 5).match?(e, a)
    else
      Vectory.ui.debug("Using a default matcher.")

      values_match?(e, a)
    end
  end

  def sub_time_and_version(str)
    str.sub(/%%CreationDate:(.+)$/, "%%CreationDate:")
      .sub(/%%Creator: cairo(.+)$/, "%%Creator: cairo")
  end

  diffable
end

RSpec::Matchers.define :be_equivalent_svg_to do |expected|
  match do |actual|
    e = sub_unimportant(expected)
    a = sub_unimportant(actual)
    values_match?(e, a)
  end

  def sub_unimportant(str)
    str.sub(/sodipodi:docname=(.+)$/, "sodipodi:docname=")
  end

  diffable
end
