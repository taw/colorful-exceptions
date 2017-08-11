require "pathname"
Gem::Specification.new do |s|
  s.name         = "colorful-exceptions"
  s.version      = "0.1.20170811"
  s.date         = "2017-08-11"

  s.summary      = "Colorful exception backtraces"
  s.description  = "Recolors exception backtraces. Compatible with most software."
  s.authors      = ["Tomasz Wegrzanowski"]
  s.email        = "Tomasz.Wegrzanowski@gmail.com"
  s.files        = %W[Rakefile .rspec lib spec README.md].map{|x| Pathname(x).find.to_a.select(&:file?)}.flatten.map(&:to_s)
  s.homepage     = "https://github.com/taw/colorful-exceptions"
  s.license      = "MIT"
  # tests
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
