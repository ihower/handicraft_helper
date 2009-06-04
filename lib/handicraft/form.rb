module Handicraft
  class Form < ActionView::Helpers::FormBuilder
    helpers = field_helpers +
      %w(date_select datetime_select time_select radio_button) +
      %w(collection_select select country_select time_zone_select) -
      %w(hidden_field label fields_for)
  
    helpers.each do |name|
      define_method(name) do |field, *args|
        options = args.last.is_a?(Hash) ? args.pop : {}
  
        options.merge!( :class => name ) unless options[:class]
  
        prefix_option = ""
        postfix_option = ""
        if options[:label]
          prefix_option += label(field, options.delete(:label) , :class => "label" )
        end
  
        if options[:description]
          postfix_option += @template.content_tag(:span, options.delete(:description) , :class => "description" )
          postfix_option = @template.content_tag(:span, error_message_on(field) , :class => "error") unless error_message_on(field).blank? 
        end
        postfix_option = @template.content_tag(:span, error_message_on(field) , :class => "error") unless error_message_on(field).blank? 
        
        temp = @template.content_tag(:div, prefix_option + super + postfix_option , :class => "group" )
        
        @template.content_tag(:div, temp , :class => "fieldWithErrors" )
        
      end
    end
  
    def submit(*args)
      @template.content_tag(:div, super(*args),:class => "submit")
    end
  end
end
