module ApplicationHelper
  def us_form_with(model: nil, scope: nil, url: nil, format: nil, **options, &block)
    options[:builder] = UswdsFormBuilder

    # Build arguments hash, excluding model if it's nil
    form_args = { scope: scope, url: url, format: format, **options }
    form_args[:model] = model unless model.nil?

    form_with **form_args, &block
  end

  def local_time(time, format: nil, timezone: "America/Chicago")
    I18n.l(time.in_time_zone(timezone), format: format)
  end
end
