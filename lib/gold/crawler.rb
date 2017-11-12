require 'watir'
module Gold
  module Crawler
    GONGHANGURL = 'http://www.cngold.org/paper/gonghang.html'.freeze
    INTERVAL = 60
    class << self
      def gonghang
        begin
          browser = Watir::Browser.new
          browser.goto(GONGHANGURL)
          loop do
            price = fetch_data(browser)
            storage_data(*price)
            sleep(INTERVAL)
            browser.refresh
          end
        rescue StandardError => e
          browser.close
          retry
        end
      end

      def fetch_data(browser)
        high_price = browser.td(class: 'JO_42760q71').text
        low_price = browser.td(class: 'JO_42760q72').text
        bank_buy_price = browser.td(class: 'JO_42760q73').text
        bank_sale_price = browser.td(class: 'JO_42760q74').text
        [high_price, low_price, bank_buy_price, bank_sale_price].map(&:to_f)
      end

      def storage_data(high, low, bank_buy, bank_sale)
        today = Time.zone.today
        ActiveRecord::Base.transaction do
          high_price = HighPrice.where('created_at > ?', today).first
          if high_price.present?
            high_price.update(price: high) if high_price.price < high
          else
            HighPrice.create(price: high)
          end
          low_price = LowPrice.where('created_at > ?', today).first
          if low_price.present?
            low_prices.update(price: low) if low_price.price > low
          else
            LowPrice.create(price: low)
          end
          BankBuyPrice.create(price: bank_buy)
          BankSalePrice.create(price: bank_sale)
        end
      end
    end
  end
end