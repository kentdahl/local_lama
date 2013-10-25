require 'continuation'
module LocalLama
  module DynamicConstants

    # Lookup constants dynamically, checking for local overrides first.
    def const_missing(const_name)
      val = lookup_dynamic_constant_in_context(const_name)
      val ||= @local_lama_dynamic_constants ? @local_lama_dynamic_constants[const_name] : super
    end

    # Used to specify that constants are being overriden for sub-scope(s)
    def with_local_constants(params)
      k, name = catch(:local_lama_dynamic_constants_context) { return yield }
      k.call(params[name] || lookup_dynamic_constant_in_context(name))
    end

    # Go up the call-chain looking for most recent 'with_local_constants' scope...
    def lookup_dynamic_constant_in_context(name)
      callcc{|k| throw(:local_lama_dynamic_constants_context, [k, name])}
    rescue
      nil # in case we are called without 'with_local_constants' scope(s).
    end

    def convert_existing_constant_to_dynamic(const_name)
      @local_lama_dynamic_constants ||= {}
      @local_lama_dynamic_constants[const_name] = self.const_get(const_name)
      remove_const(const_name)
    end

    def constants
      (@local_lama_dynamic_constants && @local_lama_dynamic_constants.keys) || super
    end

    def self.extended(base)
      base.constants.each do |const_name|
        base.convert_existing_constant_to_dynamic(const_name)
      end
    end

  end
end
