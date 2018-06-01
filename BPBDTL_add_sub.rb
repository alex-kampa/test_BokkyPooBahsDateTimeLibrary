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

sl.h1 "Starting ads/substract checking"
sl.p "Starting at #{t1.utc}"

###############################################################################
#
# add/sub
#

sl.p %q|assert_equal @contract.call.add_years(ts, ryy), (rdt >> ryy*12).to_i, "add_years"|
sl.p %q|assert_equal @contract.call.add_months(ts, rmm), (rdt >> rmm).to_i, "add_months"|
sl.p %q|assert_equal @contract.call.add_days(ts, rdd), (rdt + rdd).to_i, "add_days"|
sl.p %q|assert_equal @contract.call.add_hours(ts, rh), (rt + rh*60*60).to_i, "add_hours"|
sl.p %q|assert_equal @contract.call.add_minutes(ts, rm), (rt + rm*60).to_i, "add_minutes"|
sl.p %q|assert_equal @contract.call.add_seconds(ts, rs), (rt + rs).to_i, "add_seconds"|
sl.p
sl.p %q|assert_equal @contract.call.sub_years(ts, ryy), (rdt >> -ryy*12).to_i, "sub_years"|
sl.p %q|assert_equal @contract.call.sub_months(ts, rmm), (rdt >> -rmm).to_i, "sub_months"|
sl.p %q|assert_equal @contract.call.sub_days(ts, rdd), (rdt - rdd).to_i, "sub_days"|
sl.p %q|assert_equal @contract.call.sub_hours(ts, rh), (rt - rh*60*60).to_i, "sub_hours"|
sl.p %q|assert_equal @contract.call.sub_minutes(ts, rm), (rt - rm*60).to_i, "sub_minutes"|
sl.p %q|assert_equal @contract.call.sub_seconds(ts, rs), (rt - rs).to_i, "sub_seconds"|

imax = 100_000
epoch = Date.new(1970,1,1)
@errors = []
@num_expected_failures = 0

(1..imax).each do |i|

  ts = rand(10_000_000_000)
  rt = Time.at(ts).utc # random time - for adding seconds
  rdt = rt.to_datetime # random dateteim - for adding days and months
    
  ryy = rand(300)
  rmm = rand(300*12)
  rdd = rand(300*12*365)
  rh = rand(300*12*365*24)
  rm = rand(300*12*365*24*60)
  rs = rand(300*12*365*24*60*60)
    
  status = "#{i} -- #{rt} +/- #{ryy}Y #{rmm}M #{rdd}D #{rh}h #{rm}m #{rs}s"
  sl.shout "\n" + status

  # additions
  
  begin
    assert_equal @contract.call.add_years(ts, ryy), (rdt >> ryy*12).to_i, "add_years"
  rescue Test::Unit::AssertionFailedError
    @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
  end

  begin
    assert_equal @contract.call.add_months(ts, rmm), (rdt >> rmm).to_i, "add_months"
  rescue Test::Unit::AssertionFailedError
    @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
  end

  begin
    assert_equal @contract.call.add_days(ts, rdd), (rdt + rdd).to_i, "add_days"
  rescue Test::Unit::AssertionFailedError
    @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
  end

  begin
    assert_equal @contract.call.add_hours(ts, rh), (rt + rh*60*60).to_i, "add_hours"
  rescue Test::Unit::AssertionFailedError
    @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
  end

  begin
    assert_equal @contract.call.add_minutes(ts, rm), (rt + rm*60).to_i, "add_minutes"
  rescue Test::Unit::AssertionFailedError
    @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
  end

  begin
    assert_equal @contract.call.add_seconds(ts, rs), (rt + rs).to_i, "add_seconds"
  rescue Test::Unit::AssertionFailedError
    @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
  end

  # subtractions
  
  begin
    assert_equal @contract.call.sub_years(ts, ryy), (rdt >> -ryy*12).to_i, "sub_years"
  rescue Test::Unit::AssertionFailedError
    @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
  rescue  
    if (rdt >> -ryy*12).to_i < 0 then
      sl.p "sub_years(#{ts}, #{ryy}) failed - that's expected"
      @num_expected_failures += 1
    else
      sl.p "unexpected error in subYears"
      @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
    end
  end

  begin
    assert_equal @contract.call.sub_months(ts, rmm), (rdt >> -rmm).to_i, "sub_months"
  rescue Test::Unit::AssertionFailedError
    @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
  rescue  
    if (rdt >> -rmm*12).to_i < 0 then
      sl.p "sub_months(#{ts}, #{rmm}) failed - that's expected"
      @num_expected_failures += 1
    else
      sl.p "unexpected error in subMonths"
      @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
    end
  end

  begin
    assert_equal @contract.call.sub_days(ts, rdd), (rdt - rdd).to_i, "sub_days"
  rescue Test::Unit::AssertionFailedError
    @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
  rescue  
    if (rdt - rdd).to_i < 0 then
      sl.p "sub_days(#{ts}, #{rdd}) failed - that's expected"
      @num_expected_failures += 1
    else
      sl.p "unexpected error in subDays"
      @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
    end
  end

  begin
    assert_equal @contract.call.sub_hours(ts, rh), (rt - rh*60*60).to_i, "sub_hours"
  rescue Test::Unit::AssertionFailedError
    @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
  rescue  
    if (rt - rh*60*60).to_i < 0 then
      sl.p "sub_hours(#{ts}, #{rh}) failed - that's expected"
      @num_expected_failures += 1
    else
      sl.p "unexpected error in subHours"
      @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
    end
  end

  begin
    assert_equal @contract.call.sub_minutes(ts, rm), (rt - rm*60).to_i, "sub_minutes"
  rescue Test::Unit::AssertionFailedError
    @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
  rescue  
    if (rt - rm*60).to_i < 0 then
      sl.p "sub_minutes(#{ts}, #{rm}) failed - that's expected"
      @num_expected_failures += 1
    else
      sl.p "unexpected error in subMinutes"
      @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
    end
  end

  begin
    assert_equal @contract.call.sub_seconds(ts, rs), (rt - rs).to_i, "sub_seconds"
  rescue Test::Unit::AssertionFailedError
    @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
  rescue  
    if (rt - rs).to_i < 0 then
      sl.p "sub_seconds(#{ts}, #{rs}) failed - that's expected"
      @num_expected_failures += 1
    else
      sl.p "unexpected error in subSeconds"
      @errors << $!.to_s.gsub!(/\n/, " ") + " @ " + status
    end
  end
  
end
  
#

sl.p
t2 = Time.now()
sl.p "Ending at #{t2.utc} -- after #{(t2 - t1)/60} minutes"
sl.p "Number of checks: #{imax}"
sl.p "Errors found: #{@errors.length}"
sl.p
sl.p "Substraction failures (expected): #{@num_expected_failures}"

if @errors.length > 0 then
  sl.p "\nERRORS:"
  @errors.each do |err|
    sl.p err
  end
end

tname = File.basename(__FILE__).gsub(/.rb$/, "")
write_to_file(sl.sLog, "#{tname}.log")

