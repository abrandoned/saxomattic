# Saxomattic

## Installation

Add this line to your application's Gemfile:

    gem 'saxomattic'

Or install it yourself as:

    $ gem install saxomattic

## Usage

Saxomattic is a combination of [sax-machine](https://github.com/pauldix/sax-machine) and [active_attr](https://github.com/cgriego/active_attr)
If you want to know more about those probjects, check them out!

Saxomattic allows for a declarative syntax to define "models" that are mappable to xml documents so xml parsing
is declarative (through sax-machine semantics) and typecasting/attribute presence/default values are provided by
active_attr.  So.......how about an example? (let's walk through the spec example)

```ruby
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

  class SaxTesterSomething
    include Saxomattic

    attribute :baz
    attribute :foo, :type => Integer
    attribute :iso_8701, :type => Date
    attribute :date, :type => Date
    attribute :datetime, :type => DateTime
    attribute :embedded, :elements => true, :class => SaxTesterEmbedded
  end

  xml = <<-XML
    <test>
      <baz>baz</baz>
      <iso_8701>2013-01-13</iso_8701>
      <datetime>2013-08-13T14:45:55-06:00</datetime>
      <embedded>
        <foo>2</foo>
        <embed>HERE!</embed>
        <embedception type="TYPE">VALUE</embedception>
      </embedded>
      <date>2013-08-13</date>
      <foo>2</foo>
    </test>
    XML
```

The classes above `SaxTesterEmbedception`, `SaxTesterEmbedded`, `SaxTesterSomething` are the data models that map to the xml assigned to variable `xml`.
Instead of the `sax-machine` `element` syntax we have standardized on using `attribute` to declare the attributes and how a model maps to the xml document. Any override of the attribute that would typically be handled in `sax-machine` by using `elements`, `attribute`, `value` need to be accessed through the hash syntax ... ie `attribute :type, :attribute => true` tells active_attr that the attribute `type` should have setters/getters and tells `sax-machine` that the value should come from the attribute on the xml node `type`.

Parsing xml:

```ruby
  something = SaxTesterSomething.parse(xml)

  something.baz                               # => baz
  something.foo                               # => 2
  something.foo_before_type_cast              # => "2"
  something.embedded.size                     # => 1
  something.embedded.first.foo                # => 2
  something.embedded.first.embedception.type  # => "TYPE"
  something.embedded.first.embedception.value # => "VALUE"
```

Based on this short example, hopefully you can see that declaring your data models is a great way to make data models based on xml documents easier to work with. And if you don't .... do something else!

Enjoy!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
