module ApplicationHelper
  def icon(name, attributes = nil)
    content_tag :i, '', (attributes || {}).merge(class: "glyphicon glyphicon-#{name}")
  end

  def boolean(value)
    icon(!!value ? 'ok' : 'remove')
  end

  def render_value(value)
    value.present? ? value : t('value.blank')
  end
end
