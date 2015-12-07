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