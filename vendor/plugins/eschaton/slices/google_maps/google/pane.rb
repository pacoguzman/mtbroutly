module Google

  # Represents a pane that can be added to the map using Map#add_pane. Useful when building your own map controls that 
  # contain html.
  class Pane < MapObject
    
    # ==== Options:
    #
    # * +text+ - Optional
    # * +partial+ - Optional
    #
    # * +css_class+, Optional, defaulted to 'pane'.
    # * +anchor+ - Optional, defaulted to +top_left+
    # * +offset+ - Optional, defaulted to [10, 10]
    def initialize(options = {})
      options.default! :var => 'pane', :css_class => 'pane', :anchor => :top_left,
                       :offset => [10, 10]

      super

      pane_options = {}

      pane_options[:id] = self.var.to_s
      pane_options[:position] = OptionsHelper.to_google_position(options)
      pane_options[:text] = OptionsHelper.to_content(options)
      pane_options[:css_class] = options[:css_class].to_s

      if create_var?
        google_options = pane_options.to_google_options(:dont_convert => [:position])
        self << "#{self.var} = new GooglePane(#{google_options});"      
      end
    end
    
    # Replaces the html of the pane. Works in the same way as JavascriptGenerator#replace_html
    #
    #  pane.replace_html "This is new html"
    #  pane.replace_html :text => "This is new html"    
    #  pane.replace_html :partial => 'new_html'
    def replace_html(options)
      text = options.extract(:text) if options.is_a?(Hash)

      self.script.replace_html self.var, text || options
    end

  end
end