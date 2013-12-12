module CoursesHelper
	def is_teacher?(user, course)
		course.teachers.include?(user.id)
	end

	def is_member?(user, course)
		course.users.include?(user)
	end
end
