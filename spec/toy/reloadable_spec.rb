require 'helper'

describe Toy::Reloadable do
  uses_constants('User', 'Game')

  describe "#reload" do
    before do
      User.attribute(:name, String)
      @user = User.create(:name => 'John')
    end
    let(:user) { @user }

    it "reloads id from database" do
      id = user.id
      user.reload
      user.id.should == id
    end

    it "reloads record from the database" do
      user.name = 'Steve'
      user.reload
      user.name.should == 'John'
    end

    it "is still persisted" do
      user.should be_persisted
      user.reload
      user.should be_persisted
    end

    it "returns the record" do
      user.name = 'Steve'
      user.reload.should equal(user)
    end

    it "resets instance variables" do
      user.instance_variable_set("@foo", true)
      user.reload
      user.instance_variable_get("@foo").should be_nil
    end

    it "resets lists" do
      User.list(:games)
      game = Game.create
      user.update_attributes(:games => [game])
      user.games = []
      user.games.should == []
      user.reload
      user.games.should == [game]
    end

    it "resets references" do
      Game.reference(:user)
      game = Game.create(:user => user)
      game.user = nil
      game.user.should be_nil
      game.reload
      game.user.should == user
    end

    it "raises NotFound if does not exist" do
      user.destroy
      lambda { user.reload }.should raise_error(Toy::NotFound)
    end

    it "reloads defaults" do
      User.attribute(:skills, Array)
      @user.reload
      @user.skills.should == []
    end

    it "reloads attributes protected from mass assignment" do
      User.attribute(:admin, Boolean)
      User.attr_accessible(:name)
      user = User.new(:name => 'John')
      user.admin = true
      user.save
      user.reload.admin.should be_true
    end
  end
end