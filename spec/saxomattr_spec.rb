require 'spec_helper'

class SaxTesterSomething
  include Saxomattr

  attribute :foo, :type => Integer
  attribute :iso_8701, :type => Date
  attribute :date, :type => Date
  attribute :datetime, :type => DateTime
end

describe ::Saxomattr do

  let(:xml) {
    <<-XML
    <test>
      <iso_8701>2013-01-13</iso_8701>
      <datetime>#{DateTime.current}</datetime>
      <date>#{Date.today}</date>
      <foo>2</foo>
    </test>
    XML
  }

  it "actually works!" do
    something = SaxTesterSomething.new.parse(xml.strip)
    binding.pry    
  end

end
