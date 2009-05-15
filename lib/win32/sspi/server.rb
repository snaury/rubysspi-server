# Copyright (c) 2009 Alexey Borzenkov
#
# The rubysspi gem provides a ruby interface to the SSPI functions in Windows
# but it is mostly concerned with the client side of SSPI, to get through corporate
# firewalls with NTLM.
#
# This gem extends it to also support server side SSPI
#
# Originally part of mongrel-ntlm (c) 2008 Seggy Umboh

require 'win32/sspi'

module Win32
  module SSPI
    SECPKG_ATTR_NAMES = 0x00000001
    ASC_REQ_DELEGATE = 0x00000001

    module API
      AcceptSecurityContext = Win32API.new('secur32', 'AcceptSecurityContext', 'pppLLpppp', 'L')
      FreeContextBuffer = Win32API.new('secur32', 'FreeContextBuffer', 'P', 'L')
      QueryContextAttributes = Win32API.new('secur32', 'QueryContextAttributes', 'pLp', 'L')
      Strncpy = Win32API.new('msvcrt', 'strncpy', 'PLL', 'L')
    end

    class SecPkgCredentials_Names
      BUF_SZ = 512

      def initialize
        @buffer = "\0" * BUF_SZ
      end

      def to_s
        API::Strncpy.call(@buffer, @struct.unpack('L')[0], BUF_SZ-1) if @buffer.rstrip.empty?
        @buffer.rstrip
      end

      def to_p
        @struct ||= [@buffer].pack('p')
      end

      def cleanup
        API::FreeContextBuffer.call(self.to_p)
      end
    end

    class NegotiateServer
      WORD_SZ = [0].pack('L').size
      attr_accessor :package

      def initialize(package = "NTLM")
        @package = package
      end

      def acquire_credentials_handle
        @credentials = CredHandle.new

        result = SSPIResult.new(API::AcquireCredentialsHandle.call(
          nil,
          @package,
          SECPKG_CRED_INBOUND,
          nil,
          nil,
          nil,
          nil,
          @credentials.to_p,
          TimeStamp.new.to_p
        ))
        raise "AcquireCredentialsHandle Error: #{result}" unless result.ok?
      end

      def accept_security_context(token)
        incoming = SecurityBuffer.new(token)
        outgoing = SecurityBuffer.new

        current_context = @context.nil? ? nil : @context.to_p
        @context ||= CtxtHandle.new
        @contextAttributes = "\0" * WORD_SZ

        result = SSPIResult.new(API::AcceptSecurityContext.call(
          @credentials.to_p,
          current_context,
          incoming.to_p,
          ASC_REQ_DELEGATE,
          SECURITY_NETWORK_DREP,
          @context.to_p,
          outgoing.to_p,
          @contextAttributes,
          TimeStamp.new.to_p
        ))
        raise "AcceptSecurityContext Error: #{result}" unless result.ok?

        Base64.encode64(outgoing.token).delete("\n")
      end

      def get_username_from_context
        return @username unless @username.nil?
        return nil if @context.nil?

        names = SecPkgCredentials_Names.new
        result = SSPIResult.new(API::QueryContextAttributes.call(
          @context.to_p,
          SECPKG_ATTR_NAMES,
          names.to_p
        ))
        @username = names.to_s if result.ok?
      ensure
        names.cleanup
      end

      def cleanup
        API::FreeCredentialsHandle.call(@credentials.to_p) unless @credentials.nil?
        API::DeleteSecurityContext.call(@context.to_p) unless @context.nil?
        @credentials = @context = @contextAttributes = nil
      end
    end
  end
end
