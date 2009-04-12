require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class PaneTest < Test::Unit::TestCase

  def test_initialize
    Eschaton.with_global_script do |script|
      map = Google::Map.new
      
      assert_output_fixture 'pane = new GooglePane({cssClass: "pane", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10)), text: "Poly Jean Harvey is indeed a unique women"});
                             map.addControl(pane);',
                            script.record_for_test {
                              map.add_control Google::Pane.new(:text => 'Poly Jean Harvey is indeed a unique women')
                            }
                            
      assert_output_fixture 'pane = new GooglePane({cssClass: "pane", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(10, 10)), text: "Poly Jean Harvey is indeed a unique women"});
                             map.addControl(pane);',                            
                            script.record_for_test {
                              map.add_control Google::Pane.new(:text => 'Poly Jean Harvey is indeed a unique women', :anchor => :top_right)
                            }
                            
      assert_output_fixture 'pane = new GooglePane({cssClass: "pane", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(10, 30)), text: "Poly Jean Harvey is indeed a unique women"});
                             map.addControl(pane);',                            
                            script.record_for_test {                            
                              map.add_control Google::Pane.new(:text => 'Poly Jean Harvey is indeed a unique women', :anchor => :top_right,
                                                               :offset => [10, 30])
                            }
                            
      assert_output_fixture 'pane = new GooglePane({cssClass: "green", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10)), text: "Poly Jean Harvey is indeed a unique women"});
                             map.addControl(pane);',                            
                            script.record_for_test {
                              map.add_control Google::Pane.new(:text => 'Poly Jean Harvey is indeed a unique women', :css_class => :green)
                            }
                            
      assert_output_fixture 'pane = new GooglePane({cssClass: "green", id: "pane", position: new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10)), text: "test output for render"});
                            map.addControl(pane);',                            
                            script.record_for_test {
                              map.add_control Google::Pane.new(:partial => 'jump_to', :css_class => :green)
                            }
    end
  end
  
  def test_pane_id
    Eschaton.with_global_script do |script|
      output = 'my_pane = new GooglePane({cssClass: "pane", id: "my_pane", position: new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 10)), text: "Poly Jean Harvey is indeed a unique women"});'
     
      assert_output_fixture output,
                            script.record_for_test {
                              Google::Pane.new(:var => :my_pane, :text => 'Poly Jean Harvey is indeed a unique women')
                            }

      assert_output_fixture output, 
                            script.record_for_test {
                              Google::Pane.new(:var => 'my_pane', :text => 'Poly Jean Harvey is indeed a unique women')
                            }
    end
  end
  
  def test_replace_html
    Eschaton.with_global_script do
      pane = Google::Pane.new(:text => 'Poly Jean Harvey is indeed a unique women')

      assert_output_fixture 'Element.update("pane", "This is new html");',
                            Eschaton.with_global_script  {
                              pane.replace_html :text => "This is new html" 
                            }

      assert_output_fixture 'Element.update("pane", "This is new html");',
                            Eschaton.with_global_script {
                              pane.replace_html "This is new html" 
                            }

      assert_output_fixture 'Element.update("pane", "test output for render");',
                            Eschaton.with_global_script {
                              pane.replace_html :partial => 'new_html' 
                            }
    end    
  end
  
end