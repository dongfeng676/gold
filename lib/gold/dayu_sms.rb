module Gold
  module DayuSms
    PHONENUM = '15921076830'.freeze
    def template_send(price)
      Alidayu::Sms.send_code_for_gold(PHONENUM, { name: '把酒东风', value: price }, '')
    end

    def custom_send(price)
      options = {
        sms_param: "{'name':'把酒东风','value': #{price}}",
        phones: '18321108964',
        extend: '',
        sms_free_sign_name: '张明举', # 短信签名
        sms_template_code: 'SMS_111895208' # 短信模板
      }
      result = AlidayuSmsSender.new.batchSendSms(options)
    end
  end
end