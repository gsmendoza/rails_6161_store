class SolidusPay::PaymentMethod < Spree::PaymentMethod
  def payment_source_class
    SolidusPay::Transaction
  end

  def supports?(source)
    source.is_a?(payment_source_class)
  end

  def reusable_sources(order)
    return [] unless order.user

    order.user.wallet_payment_sources.map(&:payment_source).select do |source|
      supports?(source) && source.reusable?
    end
  end
end
