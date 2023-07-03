# frozen_string_literal: true

require 'json'
require 'dry-types'
require 'dry-struct'

require_relative "ddb_ruby/version"
require_relative "ddb_ruby/structs"

module DdbRuby
  class Error < StandardError; end
  # Your code goes here...
end
