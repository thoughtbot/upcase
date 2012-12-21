module RailsAdminHelper
  def month_filter(date)
    date_format = I18n.t('admin.misc.filter_date_format')
    start_date = date.beginning_of_month.strftime(date_format)
    end_date = date.end_of_month.strftime(date_format)
    {created_at: {1 => {o: :between, v: ['', start_date, end_date]}}}
  end
end
