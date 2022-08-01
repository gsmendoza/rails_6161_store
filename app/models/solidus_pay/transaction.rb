class SolidusPay::Transaction < Spree::PaymentSource
  self.table_name = "solidus_pay_transactions"
end
