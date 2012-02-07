Test::Unit::FasterSkip
======================

This gem allows you to skip setup/teardown for tests that are omitted/pending.
If your setup method is very heavy-weight, this can save you a lot of time!

To use FasterSkip, just change this:

```ruby
class MyTestCase < Test::Unit::TestCase
  def test_cool_feature
    pend('Bug #159: To be implemented.')
    # TODO: Figure out how to test this.
  end

  def test_platform_specific_feature
    omit_if(File::ALT_SEPARATOR, "Skipping test on Windows/VMS")
    # ...
  end
end
```

To this:

```ruby
require 'test-unit-fasterskip'
class MyTestCase < Test::Unit::TestCase
  pend('Bug #159: To be implemented.')
  def test_cool_feature
    # TODO: Figure out how to test this.
  end

  omit_if("Skipping test on Windows/VMS") { File::ALT_SEPARATOR }
  def test_platform_specific_feature
    # ...
  end
end
```

Note that neither `setup` *nor* `teardown` will be run in these scenarios. You
can also call `omit_unless`, which negates the value of the boolean returned by
your block. Your `omit_if` block will be passed the current TestCase instance as
its first argument.
