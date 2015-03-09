require "rails_helper"
require "pry"

RSpec.describe Users, :type => :model do
  it "orders by last name" do
    tester1 = Users.create!(email: "tester1@gmail.com")
    tester2 = Users.create!(email: "tester2@gmail.com")

    expect(Users.order('email ASC')).to eq([tester1, tester2])
  end
end
