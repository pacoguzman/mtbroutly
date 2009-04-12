# Provides access to global objects of interest.
module Eschaton # :nodoc:

  def self.current_view=(view)
    @@current_view = view
  end

  def self.current_view
    @@current_view
  end

  def self.dependencies
    if defined?(ActiveSupport::Dependencies)
      ActiveSupport::Dependencies
    else
      Dependencies
    end
  end

  # works like rails url for only with more options!!!!
  def self.url_for_javascript(options)
    url = self.current_view.url_for(options)

    interpolate_symbol, brackets = '#', '()'
    url.scan(/#{interpolate_symbol.escape}[\w\.#{brackets.escape}]+/).each do |javascript_variable|
      interpolation = javascript_variable.gsub(interpolate_symbol.escape, '')
      interpolation.gsub!(brackets.escape, brackets)

      url.gsub!(javascript_variable, "' + #{interpolation} + '")
    end

    url.gsub!('&amp;', '&')

    "'#{url}'"
  end

  # Returns a JavascriptGenerator which is extended by all eschaton slices.
  def self.javascript_generator
    ActionView::Helpers::PrototypeHelper::JavaScriptGenerator.new(self.current_view){}
  end

  def self.with_global_script(script = Eschaton.javascript_generator, options = {})
    options.default! :reset_after => false

    previous_script = unless options[:reset_after]
                        self.global_script
                      end

    self.global_script = script

    yield script

    self.global_script = previous_script

    script
  end

  def self.global_script=(script)
    Thread.current[:eschaton_global_script] = script
  end

  def self.global_script
    global_script = Thread.current[:eschaton_global_script]

    yield global_script if block_given?

    global_script
  end

end