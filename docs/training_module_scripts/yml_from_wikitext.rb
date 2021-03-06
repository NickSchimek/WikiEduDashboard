# Take wikitext for a training module, convert it into yml files.
require "#{Rails.root}/lib/training/wiki_slide_parser"

module_number = 26
suffix = 'fellows'
module_slug = 'moving-live-fellows'
base_path = "#{Rails.root}/training_content/wiki_ed/slides/#{module_number}-#{module_slug}"
# input = <<-STUFF


# Write to a .yml file, return the id and slug base for populating the module.
def to_yml(wikitext, slide_id, suffix, base_path)
  parser = WikiSlideParser.new(wikitext)
  slug_base = parser.title.downcase.split(/\W+/).join('-')
  slug = "#{slide_id}-#{slug_base}-#{suffix}"
  filename = "#{base_path}/#{slug}.yml"
  File.write filename, { 'title' => parser.title, 'content' => parser.content, 'id' => slide_id }.to_yaml
  return [slide_id, "#{slug_base}-#{suffix}"]
end

# manually construct the module .yml file
def write_module_file(slide_slugs, module_number, module_slug)
  lines = []
  lines << "name:"
  lines << "id: #{module_number}"
  lines << "description:"
  lines << "estimated_ttc:"
  lines << "slides:"
  slide_slugs.each do |slug|
    lines << "  - slug: #{slug[1]} # #{slug[0]}"
  end
  path = "#{Rails.root}/training_content/wiki_ed/modules/#{module_slug}.yml"
  File.open(path, 'w+') do |file|
    file.puts(lines)
  end
end
  
# Take a single page of wikitext, and break it into level 2 sections, one section per slide
slide_wikitexts = input.split(/\n(?===)/);

i = 0
slide_slugs = []
# write all the slides and collect the slugs and ids
slide_wikitexts.each do |slide_wikitext|
  next if slide_wikitext.blank?
  i += 1
  padded_slide_count = "%02d" % i
  slide_id = "#{module_number}#{padded_slide_count}".to_i
  slide_slugs << to_yml(slide_wikitext, slide_id, suffix, base_path)
end;

# write the module yml file
write_module_file(slide_slugs, module_number, module_slug)

# Now fill in the missing fields in the module .yml file and reload the trainings
