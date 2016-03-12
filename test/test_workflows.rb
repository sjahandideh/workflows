require 'minitest/autorun'
require 'workflows'

class TestWorkflows < Minitest::Test

  def test_hi
    assert "Hey Shamim",
      Workflows.greet('Shamim')
  end
end
