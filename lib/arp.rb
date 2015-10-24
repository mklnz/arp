require "arp/version"
require 'forwardable'
require 'ostruct'

module Arp
  class Cache
    include Enumerable

    extend Forwardable
    def_delegators :collection, :each, :<<, :size


    attr_reader :cmd

    def initialize(cmd = "arp -a")
      @cmd = cmd
    end

    def collection
      output = `#{@cmd}`.split("\n")

      output.map do |line|
        columns = line.split(/\s+/)
        hostname = columns[0]
        ip = columns[1][1..-2]
        mac = columns[3]
        OpenStruct.new(hostname: hostname,
                       ip: ip,
                       mac: mac)
      end
    end
  end
end
