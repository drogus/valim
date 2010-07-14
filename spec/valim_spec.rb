require 'spec_helper'

describe "Valim" do
  it "has doubts" do
    Valim.have_doubts { 5 > 2 }.should == confirm
    Valim.have_doubts { 5 < 2 }.should == deny
  end

  it "calls you dude" do
    comeon = common
    (dude comeon).to_s.should == "Dude! Come on"
  end

  it "facepalms" do
    lambda { facepalm }.should raise_error(Valim::FacepalmError)
  end

  it "double facepalms" do
    lambda { double_facepalm }.should raise_error(Valim::DoubleFacepalmError)
  end

  describe "Truth" do
    it "is confirmed" do
      true.inspect.should == "confirm"
    end

    it "provides confirm" do
      confirm.should == true
    end

    it "confirms" do
      true.confirm?.should == confirm
      "truth".confirm?.should == confirm
      true.deny?.should == deny
      "truth".deny?.should == deny
    end

    it "confirms or denies" do
      true.confirm_deny?.should == confirm
      "truth".confirm_deny?.should == confirm
    end

    it "confirms / denies" do
      (confirm / deny?).should == confirm
      (Object.new.confirm / deny?).should == confirm
    end

    it "is in denial" do
      (false.confirm / deny?).should == deny
    end
  end

  describe "Lies" do
    it "is denied" do
      false.inspect.should == "deny"
    end

    it "provides deny" do
      deny.should == false
    end

    it "denies" do
      false.deny?.should == confirm
      nil.deny?.should == confirm
      false.confirm?.should == deny
      nil.confirm?.should == deny
    end

    it "confirms or denies" do
      false.confirm_deny?.should == deny
      nil.confirm_deny?.should == deny
    end
  end

  describe "common" do
    it "says come on" do
      common.to_s.should == "come on"
    end

    it "accepts common.js" do
      common.js.should == "common.js"
    end

    it "accepts other commons" do
      common.carl.should == "common.carl"
    end
  end

  describe "brodelize" do
    it "makes brodels" do
      brodelize(2).to_s.should == "brodel\nbrodel\n"
    end
  end

  describe "pay attention" do
    it "invokes the block" do
      variable = nil
      pay_attention { variable = 1 }
      variable.should == 1
    end

    it "changes the priority of the current thread to 1000" do
      priority = nil
      pay_attention { priority = Thread.current.priority }
      priority.should == 1000
    end

    describe "on a Thread" do
      after do
        @thread.kill
      end

      it "wakes up and changes the priority of the Thread" do
        variable = nil
        @thread = Thread.new { sleep; variable = Thread.current.priority }

        sleep 0.01
        @thread.pay_attention
        sleep 0.01
        variable.should == 1000
      end
    end
  end
end
