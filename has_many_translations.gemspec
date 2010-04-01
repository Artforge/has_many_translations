# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{has_many_translations}
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["opengotham"]
  s.date = %q{2010-04-01}
  s.description = %q{Keep a DRY multilingual translation of your ActiveRecord models' textual attributes}
  s.email = %q{mjording@openogotham.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "generators/has_many_translations/has_many_translations_generator.rb",
     "generators/has_many_translations/templates/initializer.rb",
     "generators/has_many_translations/templates/migration.rb",
     "has_many_translations.gemspec",
     "init.rb",
     "lib/has_many_translations.rb",
     "lib/has_many_translations/configuration.rb",
     "lib/has_many_translations/control.rb",
     "lib/has_many_translations/creation.rb",
     "lib/has_many_translations/options.rb",
     "lib/has_many_translations/translated.rb",
     "lib/has_many_translations/translation.rb",
     "lib/has_many_translations/translation_jobs.rb",
     "lib/has_many_translations/translations.rb",
     "tasks/has_many_translations_tasks.rake"
  ]
  s.homepage = %q{http://github.com/opengotham/has_many_translations}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Makes models' speak in tongues}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.1.0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_runtime_dependency(%q<sishen-rtranslate>, [">= 0"])
      s.add_runtime_dependency(%q<activequeue>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.1.0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<sishen-rtranslate>, [">= 0"])
      s.add_dependency(%q<activequeue>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.1.0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<sishen-rtranslate>, [">= 0"])
    s.add_dependency(%q<activequeue>, [">= 0"])
  end
end

