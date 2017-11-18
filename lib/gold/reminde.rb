module Gold
  module Remind

    # bank_buy_price
    def today_buy_init_price
      today = Time.zone.today
      if Time.now - @send_sms_flag[:date] < 24.hours
      else

      end
      init_price = BankBuyPrice.where('created_at > ?', today).first
      init_price.price
    end

    def parse(bank_buy_price)
      remain_rules = remain_reminde_rules

      # case 1 涨
      up_value = bank_buy_price - bank_buy_init_price
      up_max_value = current_up_max_remind
      up_rules = remain_rules.where('value > ?', 0)
      up_rules.each do |rule|
        if up_value > up_max_value && up_value < rule.value
          # send sms
          Gold::DayuSms.template_send(bank_buy_price)
          UserPriceRemind.create(user_id: 1, price_space_id: rule.id, rise: true)
        end
      end
      # case 2 跌
      up_value = bank_buy_init_price - bank_buy_price
      down_max_value = current_down_max_remind
      up_rules = remain_rules.where('value > ?', 0)
      up_rules.each do |rule|
        if up_value > down_max_value && up_value < rule.value
          # send sms
          Gold::DayuSms.template_send(bank_buy_price)
          UserPriceRemind.create(user_id: 1, price_space_id: rule.id, rise: false)
        end
      end
    end

    def unreminde_rule_ids
      today = Time.zone.today
      UserPriceRemind.where('created_at > ?', today).pluck(:price_space_id)
    end

    def remain_reminde_rules
      price_space_id = unreminde_rule_ids
      PriceSpace.where.not(id: price_space_id)
    end

    def current_up_max_remind
      today = Time.zone.today
      upr = UserPriceRemind.where('created_at > ? and rise = ?', today, true).last
      upr.present? ? upr.price_space.value : 0.8
    end

    def current_down_max_remind
      today = Time.zone.today
      upr = UserPriceRemind.where('created_at > ? and rise = ?', today, false).last
      upr.present? ? upr.price_space.value : 0.8
    end
  end
end