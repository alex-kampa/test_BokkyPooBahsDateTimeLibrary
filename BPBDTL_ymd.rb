require "Ethereum.rb"
require "eth"
require "test/unit"
extend Test::Unit::Assertions

require_relative "lib/utils.rb"

##

@client = Ethereum::HttpClient.new('http://127.0.0.1:8545')
@name = "BokkyPooBahsDateTimeLibrary"
@contract_address = "0x731a10897d267e19B34503aD902d0A29173Ba4B1"
@contract_abi = File.read('abi/abi.txt')

@contract = Ethereum::Contract.create(client: @client, name: @name, address: @contract_address, abi: @contract_abi)

#

sl = SimpleLog.new({:verbose => true})
t1 = Time.now()
i = 0

sl.h1 "Starting YMD checking"
sl.p "Starting at #{t1.utc}"

###############################################################################
#
# Year

sl.h2 "Year"
sl.p "  assert_equal @contract.call._is_leap_year(yy), Date.leap?(yy)"
sl.p

(1970..2286).each do |yy|
  sl.p "#{yy}"
  assert_equal @contract.call._is_leap_year(yy), Date.leap?(yy)
  i += 1
end

###############################################################################
#
# Year, Month

sl.h2 "Year, Month"
sl.p "assert_equal @contract.call._get_days_in_month(yy, mm), days_in_month(yy, mm)"
sl.p

(1970..2286).each do |yy|
  (1..12).each do |mm|
    sl.p "#{yy} #{mm}"
    assert_equal @contract.call._get_days_in_month(yy, mm), days_in_month(yy, mm)
    i += 1
  end
end

###############################################################################
#
# Year, Month, Day

sl.h2 "Year, Month, Day"
sl.p "assert_equal @contract.call._days_from_date(yy, mm, dd), (ts/86400).to_i"
sl.p "assert_equal @contract.call.timestamp_from_date(yy, mm, dd), ts.to_i"
sl.p

(1970..2286).each do |yy|
  (1..12).each do |mm|
    (1..31).each do |dd|
      next if dd > days_in_month(yy, mm)
      sl.p "#{yy} #{mm} #{dd}"
      ts = Time.new(yy, mm, dd, 0, 0, 0, 0).to_i
      assert_equal @contract.call._days_from_date(yy, mm, dd), (ts/86400).to_i
      assert_equal @contract.call.timestamp_from_date(yy, mm, dd), ts.to_i
      i += 2
    end
  end
end

#

sl.p
t2 = Time.now()
sl.p "Ending at #{t2.utc} -- it took #{(t2 - t1)/60} minutes to do #{i} checks"

write_to_file(sl.sLog, "BPBDTL_ymd.log")


# -----------------------------------------------------------------------------

BEGIN {

  def days_in_month(yy, mm)  
    case mm  
    when 4,6,9,11 then 30  
    when 2 then (yy%4==0 && yy%100!=0 || yy%400==0) ? 29 : 28  
    else 31  
    end  
  end

}