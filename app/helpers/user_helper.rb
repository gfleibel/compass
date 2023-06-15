module UserHelper
  def match(user)
    matches = User.where(mentor: true).map do |mentor|
      common_languages = mentor.programming_language.intersection(user.programming_language)
      points = 0
      points += 4 if mentor.professional_field == user.professional_field
      points += 4 if mentor.academic_degree.downcase.delete(' ') == user.academic_degree.downcase.delete(' ')
      points += 4 if mentor.field_of_work == user.field_of_work
      points += 1 * common_languages.length
      points += 1 if mentor.state == user.state
      [mentor.id, points]
    end
    mentors_id = matches.sort_by { |match| match[1] }.reverse
    mentors = []
    mentors_id.each do |mentor|
      mentors << User.find(mentor[0])
    end
    mentors
  end
end
