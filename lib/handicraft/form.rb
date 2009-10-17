module Handicraft
  
  ActionView::Base.field_error_proc = Proc.new{ |html_tag, instance| html_tag }
      
  class Form < ActionView::Helpers::FormBuilder
    helpers = field_helpers +
      %w(date_select datetime_select time_select radio_button) +
      %w(collection_select select country_select time_zone_select) -
      %w(hidden_field label fields_for)
  
    helpers.each do |name|
      define_method(name) do |field, *args|
        options = args.last.is_a?(Hash) ? args.pop : {}

        li = ( error_message_on(field).blank? )? Handicraft::Helper::TagNode.new("li") : Handicraft::Helper::TagNode.new("li", :class => 'error' )
        li << label(field, options.delete(:label) , :class => "desc" ) if options[:label]
        
        div = Handicraft::Helper::TagNode.new("div", :class=> "col")        
        
        options[:class] = case name
          when "text_field" : 'field text'
          when "text_area" : 'field textarea'
          #when "select" : 'field select'
          #when "date_select" : 'field select'
          #when "datetime_select" : 'field select'
          #when "time_select" : 'field select'
          #when "collection_select" : 'field select'
          #when "country_select" : 'field select'
          #when "time_zone_select" : 'field select'
        end
        
        args << options
        div << super(field, *args)
        
        unless error_message_on(field).blank?
          error_msg = error_message_on(field).match(/<div class=\"formError\">(.*)<\/div>/)[1] # HACK!
          div << @template.content_tag("p", error_msg, :class => 'error')
        end
        
        div << @template.content_tag("p", options[:description], :class => "instruction" ) if options[:description]
       
        li << div        
        return li.to_s        
      end
    end
  
    def many_check_boxes(name, check_boxes_options, options = {})
      li =  Handicraft::Helper::TagNode.new("li")
      li << label(name, options.delete(:label) , :class => "desc" ) if options[:label]
      
      div = Handicraft::Helper::TagNode.new("div", :class=> "col")
      
      field_name = "#{object_name}[#{name}][]"
      check_boxes_options.each do |value, key|
        div << @template.check_box_tag(field_name, key, object.send(name).include?(key)) + " #{value} "
      end
      
      div << @template.hidden_field_tag(field_name, "")
      li << div
      
      return li.to_s
    end
      
    def submit(value, options={})
      options[:class] ||= 'submit'
      
      @template.content_tag(:li, super(value, options), :class => "buttons")
    end
  end
end