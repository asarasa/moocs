require "spec_helper"

describe Course do 
  it "has a valid factory" do
    expect(build(:course)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:course, name: nil)).to have(1).errors_on(:name)
  end 

  it "is invalid without a abstract" do
  	expect(build(:course, abstract: nil)).to have(1).errors_on(:abstract)
  end 

  it "is invalid without a desc" do
    expect(build(:course, desc: nil)).to have(1).errors_on(:desc)
  end 

  it "is invalid without a start_date" do
    expect(build(:course, start_date: nil)).to have(1).errors_on(:start_date)
  end 

  it "is invalid without a end_date" do
    expect(build(:course, end_date: nil)).to have(1).errors_on(:end_date)
  end     

  it "is invalid with a duplicate name" do
  	create(:course, name: "test")
  	expect(build(:course, name: "test")).to have(1).errors_on(:name)
  end

  it "end date cannot be smaller than start date" do
    expect(build(:course, end_date: DateTime.now - 1)).to have(1).errors_on(:end_date)
  end

  describe "members filter by type" do
    before :each do
      @student = create(:user)
      @teacher = create(:user)
      @course = create(:course)
      @members = []
      @members << create(:member, user: @student, course: @course, type: :student)
      @members << create(:member, user: @teacher, course: @course, type: :teacher)
    end

    it "return a list of members" do
      expect(@course.all_members.to_a).to eq [@student, @teacher]
    end

    it "return a list of students" do
      expect(@course.members_by(:student).to_a).to eq [@student]
    end

    it "return a list of teachers" do
      expect(@course.members_by(:teacher).to_a).to eq [@teacher]
    end

    it "receives a invalid type" do
      expect(@course.members_by(:random).to_a).to eq []
    end
  end

end