Test::Unit::BetterPend
======================

This gem allows you to skip setup/teardown for tests that are currently pending.
If your setup method is very heavy-weight, this can save you a lot of time!

To use BetterPend, just change this:

```ruby
class MyTestCase < Test::Unit::TestCase
  def test_cool_feature
    pend('Bug #159: To be implemented.')
    # TODO: Figure out how to test this.
  end
end
```

To this:

```ruby
require 'test-unit-betterpend'
class MyTestCase < Test::Unit::TestCase
  pend('Bug #159: To be implemented.')
  def test_cool_feature
    # TODO: Figure out how to test this.
  end
end
```

Note that neither setup() nor teardown() will be run in this scenario.
