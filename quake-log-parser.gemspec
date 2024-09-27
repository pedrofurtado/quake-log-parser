require_relative 'lib/quake-log-parser/version'

Gem::Specification.new do |spec|
  spec.name                        = 'quake-log-parser'
  spec.version                     = QuakeLogParser::VERSION
  spec.authors                     = ['Pedro Furtado']
  spec.email                       = ['pedro.felipe.azevedo.furtado@gmail.com']
  spec.summary                     = 'Ruby gem for quake log parsing'
  spec.description                 = 'Ruby gem for quake log parsing'
  spec.homepage                    = 'https://github.com/pedrofurtado/quake-log-parser'
  spec.license                     = 'MIT'
  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = "#{spec.homepage}/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'karafka'
  spec.add_dependency 'karafka-web'
  spec.add_development_dependency 'karafka-testing'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
