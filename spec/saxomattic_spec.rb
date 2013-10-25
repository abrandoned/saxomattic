require 'spec_helper'

class SaxTesterEmbedception
  include Saxomattic

  attribute :type, :attribute => true
  attribute :value, :value => true
  attribute :not_even_used
end

class SaxTesterEmbedded
  include Saxomattic

  attribute :embed
  attribute :foo, :type => Integer
  attribute :embedception, :class => SaxTesterEmbedception
end

class SaxTesterChild
  include Saxomattic

  attribute :name
end

class SaxTesterSomething
  include Saxomattic

  attribute :baz
  attribute :foo, :type => Integer
  attribute :iso_8701, :type => Date
  attribute :date, :type => Date
  attribute :datetime, :type => DateTime
  attribute :embedded, :elements => true, :class => SaxTesterEmbedded, :default => []
  attribute :child, :as => :children, :elements => true, :class => SaxTesterChild, :default => []
  attribute :CAPITALIZATION, :as => :capitalization
end

describe ::Saxomattic do

  let(:embedded_message) { "HERE!" }
  let(:embedception_type) { "TYPE" }
  let(:embedception_value) { "VALUE" }
  let(:foo) { 2 }
  let(:baz) { "baz" }
  let(:xml) {
    <<-XML
    <test>
      <baz>#{baz}</baz>
      <iso_8701>2013-01-13</iso_8701>
      <datetime>#{DateTime.now}</datetime>
      <embedded>
        <foo>2</foo>
        <embed>#{embedded_message}</embed>
        <embedception type="#{embedception_type}">#{embedception_value}</embedception>
      </embedded>
      <parent>
        <child>
          <name>John</name>
        </child>
        <child>
          <name>Paul</name>
        </child>
      </parent>
      <date>#{Date.today}</date>
      <foo>2</foo>
      <CAPITALIZATION>cap</CAPITALIZATION>
    </test>
    XML
  }

  subject { SaxTesterSomething.parse(xml) }

  it "extracts elements when declared as attribute" do
    subject.baz.should eq(baz)
  end

  context "TypeCasting" do
    it "typecasts integers when declared with type => Integer" do
      subject.foo.should eq(foo)
    end

    it "typecasts Dates when declared with type => Date" do
      subject.date.should be_a(Date)
      subject.date.should eq(Date.today)
    end

    it "embedded" do
      subject.embedded.should be_a(Array)
      subject.embedded.first.embed.should eq(embedded_message)
    end

    it "typecasts embedded fields" do
      subject.embedded.first.foo.should eq(foo)
    end

    it "embeds values further" do
      subject.embedded.first.embedception?.should be_true
      subject.embedded.first.embedception.type.should eq(embedception_type)
      subject.embedded.first.embedception.value.should eq(embedception_value)
      subject.embedded.first.embedception.not_even_used?.should be_false
    end

    it "extracts multiple children from a parent element" do
      subject.children.size.should eq 2
      subject.children.first.name.should eq "John"
      subject.children.last.name.should eq "Paul"
    end
  end

end
