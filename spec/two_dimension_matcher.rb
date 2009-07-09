module TwoDimensionMatchers
  class BeAsVertice
    def initialize(expected, delta = 0)
      @expected = expected
      @delta = delta
    end

    def matches?(actual)
      @actual = actual
      ((@actual[:latitude] - @expected[0]).abs < @delta) && ((@actual[:longitude] - @expected[1]).abs < @delta)
    end

    def failure_message_for_should
      "expected #{@expected.inspect} +/- (< #{@delta}), got #{@actual.inspect}"
    end

    def failure_message_for_should_not
      "expected #{@expected.inspect} +/- (< #{@delta}), got #{@actual.inspect}"
    end

    def description
      # Expected passed as array to write less code
    end
  end

  def be_as_vertice(expected, delta)
    BeAsVertice.new(expected, delta)
  end


  class BeAsPoint
    def initialize(expected, delta = 0)
      @expected = expected
      @delta = delta
    end

    def matches?(actual)
      @actual = actual
      ((@actual[0] - @expected[0]).abs < @delta) && ((@actual[1] - @expected[1]).abs < @delta)
    end

    def failure_message_for_should
      "expected #{@expected.inspect} +/- (< #{@delta}), got #{@actual.inspect}"
    end

    def failure_message_for_should_not
      "expected #{@expected.inspect} +/- (< #{@delta}), got #{@actual.inspect}"
    end

    def description
      # Expected passed as array to write less code
    end
  end

  def be_as_point(expected, delta)
    BeAsPoint.new(expected, delta)
  end
end


