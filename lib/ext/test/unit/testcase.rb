module Test::Unit
  class TestCase
    class << self
      def pend(message, *tests)
        # We capture `caller` here so that we can give a better backtrace in
        # #pending_setup.
        attribute(:pending, [caller, message], *tests)
      end
    end

    setup :pending_setup, :before => :prepend
    # We pend() before setup runs, so that we don't have to run the test's setup
    # if we're skipping it.
    def pending_setup
      begin
        pend(self[:pending][1]) if self[:pending]
      rescue PendedError => e
        # We reset the backtrace to point to the line where the 'pend' call was
        # originally made.
        e.set_backtrace(self[:pending][0])
        raise e
      end
    end

    alias_method :run_teardown_original, :run_teardown
    # We only run the #run_teardown if we're not pend-ing this test, since
    # teardown probably assumes setup() was called.
    def run_teardown(*args)
      run_teardown_original(*args) unless self[:pending]
    end
  end
end
