# Cookbook: selinux_policy
# Library: helper-disabled
# 2015, GPLv2, Neil Duff-Howie

require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

class Chef
  module SELinuxPolicy
    module Helpers
      # return true if the supplied protocol/port is allowed by selinux for the context
      def port_allowed?(context, protocol, port)
        Chef::Log.debug("port_allowed? Querying:  #{context||'any'}:#{protocol} - #{port}")

        port = port.to_i

        return true unless use_selinux

        list = shell_out!('semanage', 'port', '-l')

        list.stdout.each_line do |line|
          next unless line =~ /^([^\s]+)\s+(udp|tcp)\s+([0-9][0-9\s,-]*)/
          next unless (context.nil? || $1 == context) && $2 == protocol

          ports = $3

          Chef::Log.debug("Current port configuration for #{context||'any'}:#{protocol} - #{ports}")

          # handle, e.g. searching for '10005' in the following entry:
          # http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
          return true if ports.split(/,\s*/).detect do |p|
            p.to_i == port || (p =~ /^(\d+)-(\d+)$/ && ($1.to_i..$2.to_i).include?(port))
          end
        end

        false
      end
    end
  end
end
