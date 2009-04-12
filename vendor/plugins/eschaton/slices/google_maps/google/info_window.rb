module Google
   
  class InfoWindow < MapObject
    attr_reader :object

    def initialize(options = {})
      # TODO - Find a better name than "object"
      @object = options.extract(:object)
      options[:var] = @object.var

      super
    end

    def open(options)     
      options.default! :location => :center, :include_location => true

      location = Google::OptionsHelper.to_location(options[:location])
      location = self.object.center if location == :center      

      if options[:url]
        options[:location] = location
        
        # TODO - the way the jquery get forces use to duplicate code sucks, make OptionsHelper.to_content support URLS
        get(options) do |data|
          open_info_window_on_map :location => location, :content => data
        end        
      else
        open_info_window_on_map :location => location, :content => OptionsHelper.to_content(options)
      end
    end
    
    def open_on_marker(options)
      options.default! :include_location => true

      if options[:url]
        options[:location] = self.object.location
        
        # TODO - the way the jquery get forces use to duplicate code sucks, make OptionsHelper.to_content support URLS
        get(options) do |data|
          open_info_window_on_marker :content => data
        end
      else
        open_info_window_on_marker :content => OptionsHelper.to_content(options)
      end
    end
    
    def cache_on_marker(options)
      options.default! :include_location => true

      if options[:url]
        options[:location] = self.object.location

        # TODO - the way the jquery get forces use to duplicate code sucks, make OptionsHelper.to_content support URLS
        get(options) do |data|
          cache_info_window_for_marker :content => data
        end
      else
        cache_info_window_for_marker :content => OptionsHelper.to_content(options)
      end      
    end

    private
      def window_content(content)
        "\"<div id='info_window_content'>\" + #{content.to_js} + \"</div>\""
      end

      def open_info_window_on_map(options)
        content = window_content options[:content]
        self << "#{self.var}.openInfoWindow(#{options[:location]}, #{content});"        
      end

      def open_info_window_on_marker(options)
        content = window_content options[:content]
        self << "#{self.var}.openInfoWindow(#{content});"
      end

      def cache_info_window_for_marker(options)
        content = window_content options[:content]
        self << "#{self.var}.bindInfoWindowHtml(#{content});"
      end

      def get(options)
        if options[:include_location] == true
          options[:url][:location] = Google::UrlHelper.encode_location(options[:location])
        end

        self.script.get(options[:url]) do |data|
          yield data
        end
      end

  end
end