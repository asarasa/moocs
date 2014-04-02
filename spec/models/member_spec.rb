require "spec_helper"

describe Member do 
  before :each do
    @user = create(:user)
    @course = create(:course)
  end

  it "has a valid factory" do
    expect(build(:member, user: @user, course: @course, type: :student)).to be_valid
  end

  it "test is not a valid type" do
    expect(build(:member, user: @user, course: @course, type: "test")).to have(1).errors_on(:type)
  end

  it "returns a members by user" do
    member = create(:member, user: @user, course: @course, type: :student)
    expect(Member.by_user(:student, @user.id).to_a).to eq [member]
  end

  it "returns a members by course" do
    member = create(:member, user: @user, course: @course, type: :student)
    expect(Member.by_course(:student, @course.id).to_a).to eq [member]
  end

  it "can not be 2 equal members" do
    member = create(:member, user: @user, course: @course, type: :student)
    expect(build(:member, user: @user, course: @course, type: :student)).to_not be_valid    
  end

  it "can be 2 different members" do
    diff_user = create(:user)
    member = create(:member, user: diff_user, course: @course, type: :student)
    expect(build(:member, user: @user, course: @course, type: :student)).to be_valid    
  end

  describe "returns if a member exist" do
    context "member exist" do
      it "return true" do
        member = create(:member, user: @user, course: @course, type: :student)
        expect(Member.exist?(:student, @user, @course)).to be_true
      end
    end

    context "member doesn't exist" do
      it "return false" do
        diff_user = create(:user)
        member = create(:member, user: @user, course: @course, type: :student)
        expect(Member.exist?(:student, diff_user, @course)).to be_false
      end
    end
  end

end