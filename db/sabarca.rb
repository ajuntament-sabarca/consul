require 'database_cleaner'

DatabaseCleaner.clean_with :truncation

puts "Creating Settings"
Setting.create(key: 'official_level_1_name', value: 'Empleados públicos')
Setting.create(key: 'official_level_2_name', value: 'Organización Municipal')
Setting.create(key: 'official_level_4_name', value: 'Concejales')
Setting.create(key: 'official_level_5_name', value: 'Alcalde')
Setting.create(key: 'max_ratio_anon_votes_on_debates', value: '50')
Setting.create(key: 'max_votes_for_debate_edit', value: '1000')
Setting.create(key: 'max_votes_for_proposal_edit', value: '1000')
Setting.create(key: 'proposal_code_prefix', value: 'SAB')
Setting.create(key: 'votes_for_proposal_success', value: '100')
Setting.create(key: 'comments_body_max_length', value: '1000')

Setting.create(key: 'twitter_handle', value: '@consul_dev')
Setting.create(key: 'twitter_hashtag', value: '#consul_dev')
Setting.create(key: 'facebook_handle', value: 'consul')
Setting.create(key: 'youtube_handle', value: 'consul')
Setting.create(key: 'blog_url', value: '/blog')
Setting.create(key: 'url', value: 'http://localhost:3000')
Setting.create(key: 'org_name', value: 'participa.sabarca')
Setting.create(key: 'place_name', value: 'City')
Setting.create(key: 'feature.debates', value: "true")
Setting.create(key: 'feature.spending_proposals', value: "true")
Setting.create(key: 'feature.spending_proposal_features.voting_allowed', value: "true")
Setting.create(key: 'feature.twitter_login', value: "false")
Setting.create(key: 'feature.facebook_login', value: "false")
Setting.create(key: 'feature.google_login', value: "false")
Setting.create(key: 'per_page_code', value: "")
Setting.create(key: 'comments_body_max_length', value: '1000')

puts "Creating Geozones"

geozones = [
  ["Nucli Antic", "3,86,27,60,134,54,220,88,295,3,348,85,312,108,230,94,270,198,248,239,200,259,57,235,34,164","08740"],
  ["Centre", "54,234,200,261,185,329,115,355,125,290,105,288,90,261,50,246","08740"],
  ["El Palau", "199,258,228,253,224,292,199,290,196,292","08740"],
  ["La Solana", "190,292,222,294,224,324,193,317","08740"],
  ["La Plana", "190,317,184,342,214,352,218,325","08740"],
]
geozones.each do |name, coordinates, code|
  Geozone.create(name: name, html_map_coordinates: coordinates, census_code: code)
end

puts "Creating Users"

def create_user(email, username = Faker::Name.name)
  pwd = '12345678'
  puts "    #{username}"
  User.create!(username: username, email: email, password: pwd, password_confirmation: pwd, confirmed_at: Time.now, terms_of_service: "1")
end

admin = create_user('admin@sabarca.cat', 'admin')
admin.create_administrator

moderator = create_user('mod@sabarca.cat', 'mod')
moderator.create_moderator

valuator = create_user('valuator@sabarca.cat', 'valuator')
valuator.create_valuator

level_2 = create_user('leveltwo@sabarca.cat', 'level 2')

level_2.update(residence_verified_at: Time.now, confirmed_phone: Faker::PhoneNumber.phone_number, document_number: "2222222222", document_type: "1" )

verified = create_user('verified@sabarca.cat', 'verified')
verified.update(residence_verified_at: Time.now, confirmed_phone: Faker::PhoneNumber.phone_number, document_type: "1", verified_at: Time.now, document_number: "3333333333")

(1..5).each do |i|
  org_name = Faker::Company.name
  org_user = create_user("org#{i}@sabarca.cat", org_name)
  org_responsible_name = Faker::Name.name
  org = org_user.create_organization(name: org_name, responsible_name: org_responsible_name)

  verified = [true, false].sample
  if verified then
    org.verify
  else
    org.reject
  end
end

(1..4).each do |i|
  official = create_user("official#{i}@sabarca.cat")
  official.update(official_level: i, official_position: "Official position #{i}")
end

(1..10).each do |i|
  user = create_user("user#{i}@sabarca.cat")
  level = [1,2,3].sample
  if level >= 2 then
    user.update(residence_verified_at: Time.now, confirmed_phone: Faker::PhoneNumber.phone_number, document_number: Faker::Number.number(10), document_type: "1" )
  end
  if level == 3 then
    user.update(verified_at: Time.now, document_number: Faker::Number.number(10) )
  end
end

org_user_ids = User.organizations.pluck(:id)
not_org_users = User.where(['users.id NOT IN(?)', org_user_ids])

ActsAsTaggableOn::Tag.create!(name:  "Salut i Qualitat de Vida", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Interculturalitat", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Convivència i civisme", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Comerç", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Espai Públic i Espais Verds", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Millorem els barris", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Noves tencologies", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Societat del coneixement", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Atenció Ciutadata", featured: true, kind: "category")



