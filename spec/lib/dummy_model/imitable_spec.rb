require 'spec_helper'

describe DummyModel::Imitable do
  class ImitableTestDummy
    include DummyModel::Imitable

    attribute :name, String
    validates :name, :presence => true

    private

    def _save
      self.name.capitalize!
      true
    end
  end

  subject do
    ImitableTestDummy.new(:name => "johnny")
  end

  describe "#save" do
    context "when the subject is valid" do
      it "should save the subject" do
        subject.save
        subject.name.should eq('Johnny')
      end

      it "should return true" do
        subject.save.should be_true
      end
    end

    context "when the subject is invalid" do
      before :each do
        subject.name = nil
      end

      it "should have errors" do
        subject.save
        subject.errors.should_not be_empty
      end

      it "should return false" do
        subject.save.should be_false
      end
    end
  end

  describe "#save!" do
    context "when the subject is valid" do
      it "should save the subject" do
        subject.save!
        subject.name.should eq('Johnny')
      end

      it "should return true" do
        subject.save!.should be_true
      end
    end

    context "when the subject is invalid" do
      before :each do
        subject.name = nil
      end

      it "should raise an error" do
        expect{ subject.save! }.to raise_exception(DummyModel::RecordInvalid, "Name can't be blank")
      end
    end
  end

  describe "#==" do
    context "when the attributes of the subject match with the other object's attributes" do
      it "should return true" do
        subject.should eq(ImitableTestDummy.new(:name => 'johnny'))
      end
    end

    context "when the attributes of the subject do not match with the other object's attributes" do
      it "should return false" do
        subject.should_not eq(ImitableTestDummy.new(:name => 'Johnny'))
      end
    end
  end

  describe "#to_s" do
    it "should return a readable string representation of the object" do
      subject.to_s.should eq("ImitableTestDummy : {:name=>\"johnny\"}")
    end
  end

  describe ".create" do
    context "when the object is valid" do
      it "should save the object" do
        obj = ImitableTestDummy.create(:name => 'johnny')
        obj.name.should eq('Johnny')
      end

      it "should return the object" do
        ImitableTestDummy.create(:name => 'johnny').should be_kind_of(ImitableTestDummy)
      end
    end

    context "when the object is invalid" do
      it "should have errors" do
        obj = ImitableTestDummy.create
        obj.errors.should_not be_empty
      end

      it "should return the object" do
        ImitableTestDummy.create.should be_kind_of(ImitableTestDummy)
      end
    end
  end

  describe ".create!" do
    context "when the object is valid" do
      it "should save the object" do
        obj = ImitableTestDummy.create!(:name => 'johnny')
        obj.name.should eq('Johnny')
      end

      it "should return the object" do
        ImitableTestDummy.create!(:name => 'johnny').should be_kind_of(ImitableTestDummy)
      end
    end

    context "when the object is invalid" do
      it "should raise an error" do
        expect { ImitableTestDummy.create! }.to raise_exception(DummyModel::RecordInvalid, "Name can't be blank")
      end
    end
  end
end
