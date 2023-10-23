_replaced_trusted_proxies = nil
if ::Object.const_defined?(:ActionDispatch)
  if ::ActionDispatch.const_defined?(:RemoteIp)
    if ::ActionDispatch::RemoteIp.const_defined?(:TRUSTED_PROXIES)
      ::ActionDispatch::RemoteIp.send(:remove_const, :TRUSTED_PROXIES)
      ::ActionDispatch::RemoteIp.const_set(:TRUSTED_PROXIES, ['127.0.0.1', '::1'])
      _replaced_trusted_proxies = true
    end
  end
end

if not _replaced_trusted_proxies
  ::Object.class_eval {
    module ActionDispatch
      class RemoteIp
        TRUSTED_PROXIES = ['127.0.0.1', '::1']
      end
    end
  }
end
