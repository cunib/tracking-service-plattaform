class DatetimePickerInput < SimpleForm::Inputs::StringInput

  cattr_accessor :default_datepicker_options

  self.default_datepicker_options = { language: 'es', "internal-date-format" => "%d/%m/%Y %H:%M" }

  attr_accessor :datepicker_options

  def input_html_options
    super.merge(data: datepicker_options).tap do |hash|
      hash[:value] = value(object).try(:strftime, datepicker_options['internal-date-format']) if value(object)
    end
  end

  def datepicker_options
    @datepicker_options ||= self.class.default_datepicker_options
  end

  private

  def value(object)
    object.send @attribute_name if object
  end
end
