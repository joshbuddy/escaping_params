require 'callsite'
require "escaping_params/version"
require 'cgi'

module EscapingParams
  def self.included(o)
    o.class_eval do
      alias_method :lookup, :[]
      def [](k)
        AutoEscapingProxy.new(lookup(k))
      end
    end
  end

  def self.extended(o)
    o.instance_eval do
      alias :lookup :[]
      def [](k)
        AutoEscapingProxy.new(lookup(k))
      end
    end
  end

  class AutoEscapingProxy
    def initialize(obj)
      @obj = obj
    end

    def respond_to?(m)
      @obj.respond_to?(m)
    end

    def to_s
      if Callsite.parse(caller.first).filename == '(erb)'
        CGI.escapeHTML(@obj.to_s)
      else
        @obj.to_s
      end
    end

    def method_missing(m, *a, &b)
      @obj.method_missing(m, *a, &b)
    end
  end
end
