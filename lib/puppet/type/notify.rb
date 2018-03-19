#
# Simple module for logging messages on the client-side


module Puppet
  Type.newtype(:notify) do
    @doc = "Sends an arbitrary message to the agent run-time log."

    apply_to_all

    newproperty(:message, :idempotent => false) do
      desc "The message to be sent to the log."
      def sync
        case @resource["withpath"]
        when :true
          send(@resource[:loglevel], self.should)
        else
          Puppet.send(@resource[:loglevel], self.should)
        end
        return
      end

      def retrieve
        :absent
      end

      def insync?(is)
        if @resource[:nochange]
          sync
        end
        @resource[:nochange]
      end

      defaultto { @resource[:name] }
    end

    newparam(:withpath) do
      desc "Whether to show the full object path. Defaults to false."
      defaultto :false

      newvalues(:true, :false)
    end

    newparam(:nochange) do
      desc "If true, this resource is not treated as a change in the catalog/report.  Defaults to false."
      defaultto :false

      newvalues(:true, :false)
    end

    newparam(:name) do
      desc "An arbitrary tag for your own reference; the name of the message."
      isnamevar
    end
  end
end
