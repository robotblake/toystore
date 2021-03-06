require 'helper'

describe Toy::Equality do
  uses_objects('User', 'Person')

  describe "#eql?" do
    it "returns true if same class and id" do
      User.new(:id => 1).should eql(User.new(:id => 1))
    end

    it "return false if different class" do
      User.new(:id => 1).should_not eql(Person.new(:id => 1))
    end

    it "returns false if different id" do
      User.new(:id => 1).should_not eql(User.new(:id => 2))
    end
  end

  describe "#equal?" do
    it "returns true if same object" do
      user = User.new(:id => 1)
      user.should equal(user)
    end

    it "returns false if not same object" do
      user = User.new
      other_user = User.new
      user.should_not equal(other_user)
    end
  end

  describe "#hash" do
    it "returns the hash of the id" do
      user = User.new
      user.hash.should eq(user.id.hash)
    end
  end
end
