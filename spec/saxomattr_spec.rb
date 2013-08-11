require 'spec_helper'

class SaxTesterSomething
  include Saxomattr

  attribute :foo, :type => Integer
end

describe ::Saxomattr do

  let(:xml) {
    <<-XML
    <foo>2</foo>
    XML
  }

  it "actually works!" do
    something = SaxTesterSomething.new.parse(xml.strip)
    binding.pry    
  end

end
