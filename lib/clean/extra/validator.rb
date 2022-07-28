# frozen_string_literal: true

require_relative '../sentry'

module Clean

  # Helper module to validate values accross multiple sentries
  #
  # @example
  #   Validator.(1, :value, GuardString, GuardLenght)
  #   Validator.([[1, :value, GuardString, GuardLenght]
  #               [2, 'value', GuardString, GuardLenght]])
  #
  module Validator
    extend self

    class Failure < StandardError
      attr_reader :errors
      def initialize(errors)
        gap = "\n "; msg = "#errors detected #{errors.join(gap).prepend(gap)}"
        super(msg)
        @errors = errors
      end
    end

    def errors(*params)
      many = params.any?{|a| a.is_a?(Array)}
      chck = ->(item) {
        val, key, *sentries = item
        !!val && !!key && sentries.any?{|i| i.is_a?(Sentry)}
      }

      fail ArgumentError.new(
        <<~EOF
          wrong agruments
          - args must be either Array[value, Symbol|String, Sentry, Sentry,..]
          - or Array[[value, Symbol|String, Sentry, Sentry, ..], [value, ..]]
        EOF
      ) unless (many ? params.any?{|item| chck.(item)} : chck.(params))

      [].tap do |errs|
        errs.concat(scan(*params)) unless many
        errs.concat(params.inject([]){|errs, item| errs << scan(*item)}) if many
      end.compact.flatten
    end

    def scan(val, key, *sentries)
      # puts "val: #{val}, key: #{key}, *sentries: #{sentries}"
      sentries
        .inject([]){|memo, item| memo << item.error(val, key)}
        .compact
    end

    # scans values for errors and raises Failure when errors found
    # @see #scan for possible arguments and usage
    def errors!(*params)
      errs = errors(*params)
      fail Failure.new(errs) unless errs.empty?
    end

    alias :call :errors!
  end

end
