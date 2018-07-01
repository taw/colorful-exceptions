task "default" => "spec"
task "test" => "spec"

desc "Run tests"
task "spec" do
  sh "rspec"
end

desc "Clean up"
task "clean" do
  sh "trash colorful-exceptions-*.gem"
end

desc "Build gem"
task "gem:build" do
  sh "gem build colorful-exceptions.gemspec"
end

desc "Upload gem"
task "gem:push" => "gem:build" do
  gem_file = Dir["colorful-exceptions-*.gem"][-1] or raise "No gem found"
  sh "gem", "push", gem_file
end
