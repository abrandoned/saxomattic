require "saxomattic/version"
require "sax-machine"
require "active_attr"
require "active_support/core_ext/hash/slice"
require "active_support/core_ext/array/extract_options"
require "active_support/core_ext/string/conversions"

module Saxomattic
  ACTIVE_ATTR_ATTRIBUTES = [
    :default,
    :type,
    :typecaster
  ].freeze

  SAX_MACHINE_ATTRIBUTES = [
    :as,
    :class,
    :lazy,
    :value,
    :with
  ].freeze

  def self.included(klass)
    klass.extend(HookManagementMethods)
    klass.__send__(:include, ::SAXMachine)
    klass._capture_sax_machine_methods(klass)
    # Keep these in this order as the initialize call in
    # sax-machine doesn't `super` so we need it to be last in
    klass.__send__(:include, ::ActiveAttr::Model)
    klass._capture_active_attr_methods(klass)
    klass.extend(ClassMethods)
  end

  def initialize(*args)
    _active_attr_initialize(*args)
    _sax_machine_initialize(*args)
    super
  end

  module HookManagementMethods
    def _capture_active_attr_methods(klass)
      class << klass
        alias_method :_active_attr_attribute, :attribute
        alias_method :_active_attr_initialize, :initialize
      end
    end

    def _capture_sax_machine_methods(klass)
      class << klass
        alias_method :_sax_machine_ancestor, :ancestor
        alias_method :_sax_machine_attribute, :attribute
        alias_method :_sax_machine_element, :element
        alias_method :_sax_machine_elements, :elements
        alias_method :_sax_machine_value, :value
        alias_method :_sax_machine_initialize, :initialize
      end
    end
  end

  module ClassMethods
    def attribute(*args)
      options = args.extract_options!
      sax_field = args.first
      attr_field = options[:as] || sax_field

      # If you want to setup a default set of elements, you can!
      # :default => [ true, false, false, true ]
      if options[:elements] && !options[:elements].kind_of?(Array)
        options.merge!(:default => [])
      end

      _active_attr_attribute(attr_field, _active_attr_attributes(options.dup))

      case
      when options[:ancestor] then
        _sax_machine_ancestor(sax_field, _sax_machine_attributes(options.dup))
      when options[:attribute] then
        _sax_machine_attribute(sax_field, _sax_machine_attributes(options.dup))
      when options[:elements] then
        _sax_machine_elements(sax_field, _sax_machine_attributes(options.dup))
      when options[:value] then
        _sax_machine_value(sax_field, _sax_machine_attributes(options.dup))
      else # Default state is an element
        _sax_machine_element(sax_field, _sax_machine_attributes(options.dup))
      end
    end

    def _active_attr_attributes(options_hash = {})
      options_hash.slice(*::Saxomattic::ACTIVE_ATTR_ATTRIBUTES)
    end

    def _sax_machine_attributes(options_hash = {})
      options_hash.slice(*::Saxomattic::SAX_MACHINE_ATTRIBUTES)
    end
  end

end
