class Reports::PurchasesChartsController < ApplicationController
  def show
    render text: area_highchart('Purchases by Product', categories, series).to_js
  end

  private

  def categories
    last_twelve_months.collect do |index|
      I18n.t("date.abbr_month_names")[index.months.ago.month]
    end
  end

  def series
    products = []
    Product.all.each do |product|
      products << { name: product.sku,
                    data: sales_for_last_twelve_months(product) }
    end
    products
  end

  def last_twelve_months
    (1..12).to_a.reverse
  end

  def sales_for_last_twelve_months(product)
    last_twelve_months.collect do |index|
      startdate = index.months.ago.beginning_of_month
      enddate = index.months.ago.end_of_month
      Purchase.for_product(product).from_period(startdate, enddate).to_i
    end
  end

  def area_highchart(title, categories, series)
    {
      chart: {
        renderTo: 'container',
        type: 'area',
        backgroundColor: 'rgba(255, 255, 255, 0)'
      },
      colors: ['#058DC7', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572',
        '#FF9655', '#FFF263', '#6AF9C4'],
      legend: {
        borderWidth: 0,
        itemStyle: {
          color: '#666'
        }
      }
      title: {
        text: nil
      },
      xAxis: {
        categories: categories,
        tickmarkPlacement: 'on',
        title: {
          enabled: false
        }
      },
      yAxis: {
        endOnTick: false,
        title: {
          text: 'Dollars'
        }
      },
      plotOptions: {
        area: {
          stacking: 'normal',
          lineWidth: 1,
          marker: {
            enabled: false
          }
        }
      },
      series: series
    }
  end
end
