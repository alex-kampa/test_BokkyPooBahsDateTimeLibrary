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

sl.h1 "Starting _daysToDate checking"
sl.p "Starting at #{t1.utc}"

###############################################################################
#
# _daysToDate
#

sl.p "assert_equal @contract.call._days_to_date(i),  [yy, mm, dd]"

imax = 120_000
epoch = Date.new(1970,1,1)
@errors = []

(0..imax).each do |i|

  begin
    d = epoch + i
    sl.p "#{i} --> #{d}"
    yy = d.year
    mm = d.month
    dd = d.mday
    assert_equal @contract.call._days_to_date(i),  [yy, mm, dd], "_days_to_date"
  rescue Test::Unit::AssertionFailedError
    err = $!.to_s.gsub!(/\n/, " ") + " #{i}"
    @errors << err
  end

end
  
#

sl.p
t2 = Time.now()
sl.p "Ending at #{t2.utc} -- after #{(t2 - t1)/60} minutes"
sl.p "Number of checks: #{imax+1}"
sl.p "Errors found: #{@errors.length}"

if @errors.length > 0 then
  sl.p "\nERRORS:"
  @errors.each do |err|
    sl.p err
  end
end

tname = File.basename(__FILE__).gsub(/.rb$/, "")
write_to_file(sl.sLog, "#{tname}.log")
