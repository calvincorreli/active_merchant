require 'test_helper'

class QuickpayNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @quickpay = Quickpay::Notification.new(http_raw_data, :credential2 => "test", version: 7)
  end

  def test_accessors
    assert @quickpay.complete?
    assert_equal "000", @quickpay.status
    assert_equal "4262", @quickpay.transaction_id
    assert_equal "1353061158", @quickpay.item_id
    assert_equal "1.23", @quickpay.gross
    assert_equal "DKK", @quickpay.currency
    assert_equal Time.parse("2012-11-16 10:19:36+00:00"), @quickpay.received_at
  end

  def test_compositions
    assert_equal Money.new(123, 'DKK'), @quickpay.amount
  end

  def test_acknowledgement
    assert @quickpay.acknowledge, "should acknowledge"
  end

  def test_failed_acknnowledgement
    @quickpay = Quickpay::Notification.new(http_raw_data, :credential2 => "badmd5string")
    assert !@quickpay.acknowledge
  end

  def test_quickpay_attributes
    assert_equal "1", @quickpay.state
    assert_equal "authorize", @quickpay.msgtype
  end

  def test_generate_md5string
    assert_equal "authorize1353061158123DKK2012-11-16T10:19:36+00:001000OK000OKMerchant #1 merchant1@pil.dk4262dankortXXXXXXXXXXXX9999nets10test",
                 @quickpay.generate_md5string
  end

  def test_generate_md5check
    assert_equal "3de7b19284146aafd9eaa90b0bc230e2", @quickpay.generate_md5check
  end

  def test_respond_to_acknowledge
    assert @quickpay.respond_to?(:acknowledge)
  end

  private
  def http_raw_data
    "------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"msgtype\"\r\nContent-Type: text/plain;charset=utf-8\r\n\r\nauthorize\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"ordernumber\"\r\nContent-Type: text/plain;charset=utf-8\r\n\r\n1353061158\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"amount\"\r\nContent-Type: text/plain;charset=utf-8\r\n\r\n123\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"currency\"\r\n\r\nDKK\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"time\"\r\nContent-Type: text/plain;charset=utf-8\r\n\r\n2012-11-16T10:19:36+00:00\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"state\"\r\nContent-Type: text/plain;charset=utf-8\r\n\r\n1\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"qpstat\"\r\nContent-Type: text/plain;charset=utf-8\r\n\r\n000\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"qpstatmsg\"\r\n\r\nOK\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"chstat\"\r\n\r\n000\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"chstatmsg\"\r\n\r\nOK\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"merchant\"\r\n\r\nMerchant #1 \r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"merchantemail\"\r\n\r\nmerchant1@pil.dk\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"transaction\"\r\n\r\n4262\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"cardtype\"\r\n\r\ndankort\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"cardnumber\"\r\n\r\nXXXXXXXXXXXX9999\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"cardhash\"\r\n\r\n\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"acquirer\"\r\n\r\nnets\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"splitpayment\"\r\n\r\n1\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"fraudprobability\"\r\n\r\n\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"fraudremarks\"\r\n\r\n\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"fraudreport\"\r\n\r\n\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"fee\"\r\n\r\n0\r\n------------------------------8a827a0e6829\r\nContent-Disposition: form-data; name=\"md5check\"\r\n\r\n3de7b19284146aafd9eaa90b0bc230e2\r\n------------------------------8a827a0e6829--\r\n"
  end
end