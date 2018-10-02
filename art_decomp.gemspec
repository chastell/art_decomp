require 'English'
require 'pathname'

Gem::Specification.new do |gem|
  gem.author   = 'Piotr Szotkowski'
  gem.email    = 'p.szotkowski@tele.pw.edu.pl'
  gem.homepage = 'http://github.com/chastell/art_decomp'
  gem.license  = 'AGPL-3.0'
  gem.name     = 'art_decomp'
  gem.summary  = 'art décomp: a symbolic decomposer'
  gem.version  = '0.0.0'

  gem.files       = `git ls-files -z`.split("\0")
  gem.executables = gem.files.grep(%r{^bin/}).map { |path| File.basename(path) }
  gem.test_files  = gem.files.grep(%r{^test/.*\.rb$})

  gem.cert_chain  = ['certs/chastell.pem']
  if Pathname.new($PROGRAM_NAME).basename == Pathname.new('gem')
    gem.signing_key = Pathname.new('~/.ssh/gem-private_key.pem').expand_path
  end

  gem.add_dependency 'anima',  '~> 0.3.0'
  gem.add_dependency 'procto', '~> 0.0.2'

  gem.add_development_dependency 'bogus',          '~> 0.1.3'
  gem.add_development_dependency 'minitest',       '~> 5.6'
  gem.add_development_dependency 'minitest-focus', '~> 1.1'
  gem.add_development_dependency 'overcommit',     '~> 0.46.0'
  gem.add_development_dependency 'rake',           '~> 12.0'
  gem.add_development_dependency 'reek',           '~> 5.0'
  gem.add_development_dependency 'rubocop',        '~> 0.59.0'
end
