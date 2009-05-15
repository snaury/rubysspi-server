= Server bindings to Win32 SSPI

The rubysspi gem provides a ruby interface to the SSPI functions in Windows
but it is mostly concerned with the client side of SSPI, to get through corporate
firewalls with NTLM.

This gem extends it to also support server side SSPI

= Using rubysspi-server

Instantiate NegotiateServer instance:

  sspi = Win32::SSPI::NegotiateServer.new # optionally specifying "Negotiate" package (defaults to "NTLM")
  sspi.acquire_credentials_handle

When you receive Type1 message, accept it:

  t2 = sspi.accept_security_context(t1) # t2 is already Base64 encoded

When you receive Type3 message, accept it:

  t2 = sspi.accept_security_context(t3)
  username = sspi.get_username_from_context

Now connection is authenticated with NTLM/Negotiate.
