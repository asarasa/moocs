require "spec_helper"

describe User do 
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:user, name: nil)).to have(2).errors_on(:name)
  end

  it "is invalid without a lastname" do
    expect(build(:user, lastname: nil)).to have(2).errors_on(:lastname)
  end   

  it "is invalid without a email" do
  	expect(build(:user, email: nil)).to have(2).errors_on(:email)
  end 

  it "is invalid with a duplicate email" do
  	create(:user, email: "test@example.com")
  	expect(build(:user, email: "test@example.com")).to have(1).errors_on(:email)
  end

  it "is invalid with a incorrect email" do
  	expect(build(:user, email: "test.com")).to have(1).errors_on(:email)
  end

  describe "courses filter by type" do
    before :each do
      @user = create(:user)
      @course_student = create(:course)
      @course_teacher = create(:course)
      @members = []
      @members << create(:member, user: @user, course: @course_student, type: :student)
      @members << create(:member, user: @user, course: @course_teacher, type: :teacher)
    end

    it "return a list of members" do
      expect(@user.courses.to_a).to eq [@course_student, @course_teacher]
    end

    it "return a list of students" do
      expect(@user.courses_by(:student).to_a).to eq [@course_student]
    end

    it "return a list of teachers" do
      expect(@user.courses_by(:teacher).to_a).to eq [@course_teacher]
    end

    it "receives a invalid type" do
      expect(@user.courses_by(:random).to_a).to eq []
    end
  end

end