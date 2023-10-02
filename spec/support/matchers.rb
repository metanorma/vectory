RSpec::Matchers.define :be_equivalent_eps_to do |expected|
  match do |actual|
    e = sub_time_and_version(expected)
    a = sub_time_and_version(actual)
    values_match?(e, a)
  end

  def sub_time_and_version(str)
    str.sub(/%%CreationDate:(.+)$/, "%%CreationDate:")
      .sub(/%%Creator: cairo(.+)$/, "%%Creator: cairo")
  end

  diffable
end
