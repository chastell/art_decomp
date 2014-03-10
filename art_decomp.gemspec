Gem::Specification.new do |gem|
  gem.name     = 'art_decomp'
  gem.version  = '0.0.0'
  gem.summary  = 'art décomp: a symbolic decomposer'
  gem.homepage = 'http://github.com/chastell/art_decomp'
  gem.author   = 'Piotr Szotkowski'
  gem.email    = 'p.szotkowski@tele.pw.edu.pl'

  gem.files       = `git ls-files -z`.split "\0"
  gem.executables = gem.files.grep(%r{^bin/}).map { |path| File.basename path }
  gem.test_files  = gem.files.grep %r{^spec/.*\.rb$}

  gem.add_development_dependency 'bogus',    '~> 0.1.3'
  gem.add_development_dependency 'minitest', '~> 5.0'
  gem.add_development_dependency 'rake',     '~> 10.1'
  gem.add_development_dependency 'reek',     '~> 1.3'
  gem.add_development_dependency 'rerun',    '~> 0.9.0'
  gem.add_development_dependency 'rubocop',  '~> 0.18.0'
end
