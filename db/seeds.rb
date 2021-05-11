
[User,Questionnaire,Dimension,Question,QuestionStatement,QuestionOption,Variable,TestInvite].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE #{table.table_name} RESTART IDENTITY CASCADE")
end

User.create!(name: 'Saqib', email: "user@test.com",password: "admin123")
User.create!(name: 'Admin', email: "admin@test.com",password: "admin123",admin: true)

Questionnaire.create!(name: "Leadership Challenges")
Questionnaire.create!(name: "Leadership Mindset")

Questionnaire.find(1).dimensions.create!([{name: "Fostering Agility"},{name: "Infecting people with purpose"},{name: "Providing solid ground"},{name: "Leading the undercurrent"},{name: "Releasing Energy"},{name: "Working outside-in"},{name: "Facilitating productive collaboration"}])
Questionnaire.find(2).dimensions.create!([{name: "Locus of control"},{name: "Purpose"}	,{name: "Transparency"},{name: "Networks"},{name: "Experimentation"},{name: "Participation"},{name: "Renewal"},{name: "Empowerment"}])

Question.create!(questionnaire_id: 1,dimension_id: 1)
Question.first.statements.create!([{statement_type: "standard",full_text: "Where is his/her behaviour currently situated?"}, {statement_type: "development",full_text: "Where do you think it should be to be even more effective as a leader ?"}])
Question.first.options.create!([{option_type: "positive",full_text: "Encouraging people to experiment"}, {option_type: "negative",full_text: "Avoiding experiments"}])


Question.create!(questionnaire_id: 1,dimension_id: 2)
Question.second.statements.create!([{statement_type: "standard",full_text: "Where is his/her behaviour currently situated?"}, {statement_type: "development",full_text: "Where do you think it should be to be even more effective as a leader ?"}])
Question.second.options.create!([{option_type: "negative",full_text: "Defining very specific solutions"}, {option_type: "positive",full_text: "Putting the goal first, the way towards it secondary"}])



Question.create!(questionnaire_id: 2,dimension_id: 9)
Question.third.statements.create!([{statement_type: "standard",full_text: "Where is his/her behaviour currently situated?"}, {statement_type: "development",full_text: "Where do you think it should be to be even more effective as a leader ?"}])

Question.third.options.create!([{option_type: "positive",full_text: "People can handle freedom and autonomy. They thrive when having purpose, autonomy and mastery. “We need to give them more trust then they disserve”"}, {option_type: "negative",full_text: "People need rules, control and push to perform. The way to motivate people is to reward and punish them (carrot and stick approach)
“They have to earn trust and not the easy way”."}])


Question.create!(questionnaire_id: 2,dimension_id: 10)
Question.fourth.statements.create!([{statement_type: "standard",full_text: "Where is his/her behaviour currently situated?"}, {statement_type: "development",full_text: "Where do you think it should be to be even more effective as a leader ?"}])

Question.fourth.options.create!([{option_type: "positive",full_text: "Profit is necessary but is a consequence of having a strong purpose. Purpose is more important then profit"}, {option_type: "negative",full_text: "Making profit is the goal of a company"}])


Variable.create!(name: "INTRODUCTION",description: "This text will be displayed at the start of questionnaire to the users.")





Questionnaire.create!(name: "Leadership Behaviour")
Questionnaire.find(3).dimensions.create!([{name: "Inspiring"},{name: "Coaching"}	,{name: "Participating"},{name: "Following"},{name: "Retreating"},{name: "Resisting"},{name: "Convincing"},{name: "Directing"}])


Questionnaire.create!(name: "Leadership Behaviour - Mindset")
Questionnaire.find(4).dimensions.create!([{name: "Inspiring"},{name: "Coaching"}	,{name: "Participating"},{name: "Following"},{name: "Retreating"},{name: "Resisting"},{name: "Convincing"},{name: "Directing"}])


Variable.create!(name: 'Behavior_Assessment_Price', value: 100)
Variable.create!(name: 'Challenge_Assessment_Price', value: 200)