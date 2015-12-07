# rspec2_pass_all_expects
Failure_aggregator-like functionality implemented in RSpec 2

# Usage
```Ruby
require './pass_all_expects'
describe "test" do 
  it "expect everything to pass" do 
    expect {
      expect(1).to eq(1)
      expect(2).to eq(2)
    }.to pass_all_expects
  end

  it "expect some to fail" do 
    expect {
      expect(1).to     eq(1)
      expect(2).not_to eq(2)
    }.to pass_all_expects

  end

  it "expect all to fail" do 
    expect {
      expect(1).not_to eq(1)
      expect(2).not_to eq(2)
    }.to pass_all_expects



  end
end

```

# Results

```
Failures:

  1) test expect some to fail
     Failure/Error: expect {

       expected: value != 2
            got: 2

       (compared using ==)
     # ./pass_all_expects.rb:23:in `block in raise'
     # ./pass_all_expects.rb:21:in `callcc'
     # ./pass_all_expects.rb:21:in `raise'
     # ./example.rb:11:in `block (2 levels) in <top (required)>'

  2) test expect all to fail
     Failure/Error: expect {



       expected: value != 1
            got: 1

       (compared using ==)



       ================================================================================


       expected: value != 2
            got: 2

       (compared using ==)


     # ./pass_all_expects.rb:23:in `block in raise'
     # ./pass_all_expects.rb:21:in `callcc'
     # ./pass_all_expects.rb:21:in `raise'
     # ./example.rb:19:in `block (2 levels) in <top (required)>'

Finished in 0.003 seconds
3 examples, 2 failures

Failed examples:

rspec ./example.rb:10 # test expect some to fail
rspec ./example.rb:18 # test expect all to fail

```
