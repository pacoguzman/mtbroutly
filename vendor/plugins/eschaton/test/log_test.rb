require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)
    
class LogTest < Test::Unit::TestCase
  
  def test_write
    Eschaton.with_global_script do
      assert_equal 'GLog.writeHtml("This is a log message!");', Google::Log.write("This is a log message!")
      assert_equal 'GLog.writeHtml("Line 1<br/>Line 2");', Google::Log.write("Line 1<br/>Line 2")
    end
  end


  def test_write_to_script
    assert_output_fixture 'GLog.writeHtml("This is a log message!");
                           GLog.writeHtml("Line 1<br/>Line 2");',
                          Eschaton.with_global_script {
                            Google::Log.write("This is a log message!")
                            Google::Log.write("Line 1<br/>Line 2")
                          }
  end

end
