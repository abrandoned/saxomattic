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
  attribute :iso_8701, :typecaster => ActiveAttr::Typecasting::DateTypecaster.new
  attribute :date, :type => Date
  attribute :datetime, :type => DateTime
  attribute :embedded, :elements => true, :class => SaxTesterEmbedded, :default => []
  attribute :child, :as => :children, :elements => true, :class => SaxTesterChild, :default => []
  attribute :CAPITALIZATION, :as => :capitalization
end

describe ::Saxomattic do
  let(:iso_8701) { "2013-01-13" }
  let(:embedded_message) { "HERE!" }
  let(:embedception_type) { "TYPE" }
  let(:embedception_value) { "VALUE" }
  let(:foo) { 2 }
  let(:baz) { "baz" }
  let(:xml) {
    <<-XML
    <test>
      <baz>#{baz}</baz>
      <iso_8701>#{iso_8701}</iso_8701>
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
    expect(subject.baz).to eq(baz)
  end

  context "TypeCasting" do
    it "typecasts integers when declared with type => Integer" do
      expect(subject.foo).to eq(foo)
    end

    it "typecasts Dates when declared with type => Date" do
      expect(subject.date).to be_a(Date)
      expect(subject.date).to eq(Date.today)
    end

    it "typecasts Dates when declared with typecaster => ActiveAttr::Typecasting::DateTypecaster" do
      expect(subject.iso_8701).to be_a(Date)
      expect(subject.iso_8701).to eq(iso_8701.to_date)
    end

    it "embedded" do
      expect(subject.embedded).to be_a(Array)
      expect(subject.embedded.first.embed).to eq(embedded_message)
    end

    it "typecasts embedded fields" do
      expect(subject.embedded.first.foo).to eq(foo)
    end

    it "embeds values further" do
      expect(subject.embedded.first.embedception?).to be true
      expect(subject.embedded.first.embedception.type).to eq(embedception_type)
      expect(subject.embedded.first.embedception.value).to eq(embedception_value)
      expect(subject.embedded.first.embedception.not_even_used?).to be false
    end

    it "extracts multiple children from a parent element" do
      expect(subject.children.size).to eq 2
      expect(subject.children.first.name).to eq "John"
      expect(subject.children.last.name).to eq "Paul"
    end
  end

end
