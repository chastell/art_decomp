Gem::Specification.new do |gem|
  gem.author   = 'Piotr Szotkowski'
  gem.email    = 'p.szotkowski@tele.pw.edu.pl'
  gem.homepage = 'http://github.com/chastell/art_decomp'
  gem.license  = 'AGPL-3.0'
  gem.name     = 'art_decomp'
  gem.summary  = 'art décomp: a symbolic decomposer'
  gem.version  = '0.0.0'

  gem.files       = `git ls-files -z`.split("\0")
  gem.executables = gem.files.grep(/^bin\//).map { |path| File.basename(path) }
  gem.test_files  = gem.files.grep(/^test\/.*\.rb$/)

  gem.add_dependency 'equalizer', '~> 0.0.9'

  gem.add_development_dependency 'bogus',          '~> 0.1.3'
  gem.add_development_dependency 'minitest',       '~> 5.0'
  gem.add_development_dependency 'minitest-focus', '~> 1.1'
  gem.add_development_dependency 'rake',           '~> 10.1'
  gem.add_development_dependency 'reek',           '~> 1.6'
  gem.add_development_dependency 'rerun',          '~> 0.10.0'
  gem.add_development_dependency 'rubocop',        '~> 0.29.0'
end
