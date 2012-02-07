module Test::Unit
  class TestCase
    class << self
      # Mark test as pending (and don't run setup/teardown)
      def pend(message, *tests)
        # We capture `caller` here so that we can give a better backtrace in
        # #pending_setup.
        attribute(:fast_pending, [caller, message], *tests)
      end

      # Omit (and don't run setup/teardown) if block evalutes to true.
      def omit_if(message, *tests, &block)
        attribute(:fast_omit, [caller, message, block], *tests)
      end

      # Sugar for omit_if() { not .. }
      def omit_unless(message, *tests, &block)
        attribute(:fast_omit, [caller, message, Proc.new { not block.call }], *tests)
      end
    end

    setup :skipping_setup, :before => :prepend
    # We pend/omit() before setup runs, so that we don't have to run the test's setup
    # if we're skipping it.
    def skipping_setup
      @fast_skipped = false
      bt = nil
      begin
        if self[:fast_pending]
          bt, message = self[:fast_pending]
          pend(message)
        elsif self[:fast_omit]
          bt, message, cond_block = self[:fast_omit]
          omit_if(cond_block.call(self), message)
        end
      rescue PendedError, OmittedError => e
        @fast_skipped = true
        # We reset the backtrace to point to the line where the pend/omit call was
        # originally made.
        e.set_backtrace(bt) if bt
        raise e
      end
    end

    alias_method :run_teardown_original, :run_teardown
    # We only run the #run_teardown if we're not skipping this test, since
    # teardown probably assumes setup() was called.
    def run_teardown(*args)
      run_teardown_original(*args) unless @fast_skipped
    end
  end
end
