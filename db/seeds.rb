g1 = Group.find_or_create_by!(name: "Beta Testers")
u1 = User.find_or_create_by!(name: "John") { |u| u.group = g1 }

f1 = Feature.find_or_create_by!(name: "new_dashboard") { |f| f.default_state = false }
f2 = Feature.find_or_create_by!(name: "dark_mode") { |f| f.default_state = false }
f3 = Feature.find_or_create_by!(name: "beta_search") { |f| f.default_state = true }

# Overrides
FeatureOverride.find_or_create_by!(feature: f3, override_type: "user", override_id: u1.id) { |fo| fo.state = true }
FeatureOverride.find_or_create_by!(feature: f1, override_type: "group", override_id: g1.id) { |fo| fo.state = true }
