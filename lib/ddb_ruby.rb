# frozen_string_literal: true

require 'json'
require 'dry-types'
require 'dry-struct'

require_relative "ddb_ruby/version"
Dir.glob(File.join(File.dirname(__FILE__), '**', '*.rb'), &method(:require))

module DdbRuby
  class Error < StandardError; end
  # Your code goes here...
end
