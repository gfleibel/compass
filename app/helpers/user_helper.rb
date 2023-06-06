module UserHelper
  def match(user)
    matches = []
      User.where(mentor: true).each do |mentor|
        points = 0
        if mentor.professional_field == user.professional_field
          points += 4
        end
        if mentor.field_of_work == user.field_of_work
          points += 3
        end
        if mentor.programming_language == user.programming_language
          points += 2
        end
        if mentor.city == user.city
          points += 1
        end
        matches << [mentor.id, points]
      end
    mentors_id = matches.sort_by { |match| match[1] }.reverse
    mentors = []
    mentors_id.each do |mentor|
      mentors << User.find(mentor[0])
    end
    mentors
  end
end

# t.string "years_of_experience"
# t.integer "mentor_rating"
