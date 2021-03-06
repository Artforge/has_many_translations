# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "has_many_translations"
  s.version = "0.4.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["OpenGotham", "Artforge"]
  s.date = "2011-10-30"
  s.description = "Keep a DRY multilingual translation of your ActiveRecord models' textual attributes"
  s.email = "mjording@opengotham.com"
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "History.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "features/allow_overide_of_default_language_options_at_model_level.feature",
    "features/bypass_hmt_if_current_lang_native_language.feature",
    "features/extend_initializer_with_default_language_options.feature",
    "features/extend_initializer_with_predefined_language_options.feature",
    "features/tracker.yml",
    "generators/has_many_translations/has_many_translations_generator.rb",
    "generators/has_many_translations/templates/initializer.rb",
    "generators/has_many_translations/templates/migration.rb",
    "has_many_translations.gemspec",
    "init.rb",
    "lib/has_many_translations.rb",
    "lib/has_many_translations/configuration.rb",
    "lib/has_many_translations/control.rb",
    "lib/has_many_translations/creation.rb",
    "lib/has_many_translations/hmt_settings.rb",
    "lib/has_many_translations/options.rb",
    "lib/has_many_translations/translated.rb",
    "lib/has_many_translations/translation.rb",
    "lib/has_many_translations/translation_jobs.rb",
    "lib/has_many_translations/translations.rb",
    "lib/translation_spec.rb",
    "spec/has_many_translations.spec",
    "spec/spec_helper.rb",
    "tasks/has_many_translations_tasks.rake"
  ]
  s.homepage = "http://github.com/artforge/has_many_translations"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Makes models' speak in tongues"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<artforge-rtranslate>, [">= 1.3.4"])
      s.add_runtime_dependency(%q<to_lang>, [">= 0"])
      s.add_runtime_dependency(%q<activequeue>, [">= 0"])
      s.add_runtime_dependency(%q<settingslogic>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<launchy>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 2.1.0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_runtime_dependency(%q<artforge-rtranslate>, [">= 1.3.4"])
      s.add_runtime_dependency(%q<activequeue>, [">= 0"])
      s.add_runtime_dependency(%q<settingslogic>, [">= 0"])
    else
      s.add_dependency(%q<artforge-rtranslate>, [">= 1.3.4"])
      s.add_dependency(%q<to_lang>, [">= 0"])
      s.add_dependency(%q<activequeue>, [">= 0"])
      s.add_dependency(%q<settingslogic>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<launchy>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 2.1.0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<artforge-rtranslate>, [">= 1.3.4"])
      s.add_dependency(%q<activequeue>, [">= 0"])
      s.add_dependency(%q<settingslogic>, [">= 0"])
    end
  else
    s.add_dependency(%q<artforge-rtranslate>, [">= 1.3.4"])
    s.add_dependency(%q<to_lang>, [">= 0"])
    s.add_dependency(%q<activequeue>, [">= 0"])
    s.add_dependency(%q<settingslogic>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    #s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<launchy>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 2.1.0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<artforge-rtranslate>, [">= 1.3.4"])
    s.add_dependency(%q<activequeue>, [">= 0"])
    s.add_dependency(%q<settingslogic>, [">= 0"])
  end
end

