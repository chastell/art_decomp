require 'rake/testtask'

Rake::TestTask.new :spec do |task|
  task.test_files = FileList['spec/**/*_spec.rb']
  task.warning    = true
  Rake.application.options.suppress_backtrace_pattern =
    Regexp.union Rake::Backtrace::SUPPRESS_PATTERN, %r{/lib/rake/}
end

task default: :spec
