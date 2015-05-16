# Cookbook: selinux_policy
# Library: helper-restorecon
# 2015, GPLv2, Joerg Herzinger (www.bytesource.net)

class Chef
  module SELinuxPolicy
    module Helpers
      # Returns the system command for restorecon
      def restorecon(file_spec)
        path = file_spec.to_s.sub(/\\/,'') # Remove backslashes
        return "restorecon #{path}" if ::File.exist?(path) # Return if it's not a regular expression
        path.count('/').times do
          path = ::File.dirname(path) # Splits at last '/' and returns front part
          break if ::File.directory?(path)
        end
        # This will restore the selinux file context recursively.
        return "restorecon -R #{path}"
      end
    end
  end
end
