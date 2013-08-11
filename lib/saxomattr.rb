require 'pry'
require "saxomattr/version"
require "sax-machine"
require "active_attr"
require "active_support/core_ext/hash/slice"
require "active_support/core_ext/array/extract_options"

module Saxomattr
  ACTIVE_ATTR_ATTRIBUTES = [
    :default,
    :type
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
    klass.__send__(:include, ::ActiveAttr::TypecastedAttributes)
    klass.__send__(:include, ::ActiveAttr::QueryAttributes)
    klass._capture_active_attr_attribute_method(klass)
    klass.__send__(:include, ::SAXMachine)
    klass._capture_sax_machine_attribute_method(klass)
    klass.extend(ClassMethods)
  end

  module HookManagementMethods
    def _capture_active_attr_attribute_method(klass)
      class << klass
        alias_method :_active_attr_attribute, :attribute
      end
    end

    def _capture_sax_machine_attribute_method(klass)
      class << klass
        alias_method :_sax_machine_element, :element
        alias_method :_sax_machine_attribute, :attribute
      end
    end
  end

  module ClassMethods
    def attribute(*args)
      options = args.extract_options!
      field = args.first

      _active_attr_attribute(field, _active_attr_attributes(options))
      _sax_machine_element(field, _sax_machine_attributes(options))
      #_sax_machine_attribute(field, _sax_machine_attributes(options))
    end

    def _active_attr_attributes(options_hash = {})
      options_hash.slice!(::Saxomattr::ACTIVE_ATTR_ATTRIBUTES)
    end

    def _sax_machine_attributes(options_hash = {})
      options_hash.slice!(::Saxomattr::SAX_MACHINE_ATTRIBUTES)
    end

  end

end
