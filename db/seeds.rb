require "yaml"

skills_dir = Rails.root.join("db/seeds/skills")

Dir.glob("#{skills_dir}/*.md").each do |file|
  content = File.read(file)

  # Extract YAML frontmatter between --- delimiters
  frontmatter = content.match(/\A---\n(.*?)\n---/m)&.captures&.first
  next unless frontmatter

  attrs = YAML.safe_load(frontmatter, symbolize_names: false)
  next unless attrs["name"]

  skill = Skill.find_or_initialize_by(name: attrs["name"])
  skill.assign_attributes(
    description:      attrs["description"],
    trigger_keywords: attrs["trigger_keywords"],
    category:         attrs["category"],
    file_path:        attrs["file_path"],
    status:           attrs["status"] || "draft"
  )
  skill.save!
  puts "  #{skill.new_record? ? 'Created' : 'Updated'}: #{skill.name}"
end

puts "\nSeeded #{Skill.count} skills."
puts "Conflicts detected: #{Skill.all_conflicts.length}"
