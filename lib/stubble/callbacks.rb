module Stubble
  module Callbacks
    def stub_and_return(&block)
      add_or_get_callback(:stub_and_return, &block)
    end
    
    def stub_with_one_arg(&block)
      add_or_get_callback(:stub_with_one_arg, &block)
    end
    
    def stub_with_multi_arg(&block)
      add_or_get_callback(:stub_with_multi_arg, &block)
    end
    
    def stub_and_raise(&block)
      add_or_get_callback(:stub_and_raise, &block)
    end
    
    def reset(&block)
      add_or_get_callback(:reset, &block)
    end
    
    def add_or_get_callback(name, &block)
      @callbacks  ||= {}
      block ? @callbacks[name] = block : @callbacks[name]
    end
  end
end