# encoding: UTF-8

require 'spec_helper'

if "".respond_to?(:encode)
  kcodes = ["UTF-8"]
else
  original_kcode = $KCODE
  kcodes = ["UTF-8", "NONE"]
end

kcodes.each do |kcode|
  describe "Broficiation with #{kcode}" do
    before do
      $KCODE = kcode if original_kcode
    end

    after do
      $KCODE = original_kcode if original_kcode
    end

    it "should brotate rotate" do
      "rotate".brotate.should == "brotate"
    end

    it "should brotate josé" do
      "josé".brotate.should == "brosé"
      "José".brotate.should == "Brosé"
    end

    it "should brotate ßosé" do
      "ßosé".brotate.should == "brosé"
    end

    it "should brotate шosé" do
      "шosé".brotate.should == "brosé"
    end

    if "".encoding_aware?
      it "should brotate Шosé" do
        "Шosé".brotate.should == "Brosé"
      end
    end

    it "should not brotate 'jos valim'" do
      "jos valim".brotate.should == "jos valim"
    end

    it "should brotate phrases" do
      "Poseidon, king of the ocean".brotate.should ==
        "Broseidon, king of the brocean"
    end
  end
end