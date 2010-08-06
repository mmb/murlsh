# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{murlsh}
  s.version = "0.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew M. Boedicker"]
  s.date = %q{2010-08-05}
  s.default_executable = %q{murlsh}
  s.description = %q{url sharing site framework with easy adding, title lookup, atom feed, thumbnails and embedding}
  s.email = %q{matthewm@boedicker.org}
  s.executables = ["murlsh"]
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    ".gitignore",
     ".htaccess",
     "COPYING",
     "README.textile",
     "Rakefile",
     "VERSION",
     "bin/murlsh",
     "config.ru",
     "config.yaml",
     "lib/murlsh.rb",
     "lib/murlsh/auth.rb",
     "lib/murlsh/config_server.rb",
     "lib/murlsh/dispatch.rb",
     "lib/murlsh/doc.rb",
     "lib/murlsh/etag_add_encoding.rb",
     "lib/murlsh/failproof.rb",
     "lib/murlsh/far_future_expires.rb",
     "lib/murlsh/flickr_server.rb",
     "lib/murlsh/markup.rb",
     "lib/murlsh/must_revalidate.rb",
     "lib/murlsh/openlock.rb",
     "lib/murlsh/plugin.rb",
     "lib/murlsh/sqlite3_adapter.rb",
     "lib/murlsh/time_ago.rb",
     "lib/murlsh/twitter_server.rb",
     "lib/murlsh/unwrap_jsonp.rb",
     "lib/murlsh/uri.rb",
     "lib/murlsh/uri_ask.rb",
     "lib/murlsh/url.rb",
     "lib/murlsh/url_body.rb",
     "lib/murlsh/url_server.rb",
     "lib/murlsh/xhtml_response.rb",
     "lib/murlsh/yaml_ordered_hash.rb",
     "murlsh.gemspec",
     "plugins/add_post_50_update_feed.rb",
     "plugins/add_post_50_update_rss.rb",
     "plugins/add_post_60_notify_hubs.rb",
     "plugins/add_pre_50_lookup_content_type_title.rb",
     "plugins/add_pre_60_github_title.rb",
     "plugins/hostrec_50_redundant.rb",
     "plugins/hostrec_60_skip.rb",
     "plugins/html_parse_50_hpricot.rb",
     "plugins/time_50_ago.rb",
     "plugins/via_50_domain.rb",
     "public/css/jquery.jgrowl.css",
     "public/css/screen.css",
     "public/js/comments.json",
     "public/js/jquery-1.4.2.min.js",
     "public/js/jquery.jgrowl_compressed.js",
     "public/js/js.js",
     "public/swf/player_mp3_mini.swf",
     "spec/auth_spec.rb",
     "spec/dispatch_spec.rb",
     "spec/doc_spec.rb",
     "spec/markup_spec.rb",
     "spec/unwrap_json_spec.rb",
     "spec/uri_ask_spec.rb",
     "spec/uri_spec.rb",
     "spec/url_spec.rb",
     "spec/xhtml_response_spec.rb",
     "spec/yaml_ordered_hash_spec.rb"
  ]
  s.homepage = %q{http://github.com/mmb/murlsh}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{url sharing site framework}
  s.test_files = [
    "spec/xhtml_response_spec.rb",
     "spec/auth_spec.rb",
     "spec/yaml_ordered_hash_spec.rb",
     "spec/unwrap_json_spec.rb",
     "spec/uri_ask_spec.rb",
     "spec/dispatch_spec.rb",
     "spec/markup_spec.rb",
     "spec/url_spec.rb",
     "spec/uri_spec.rb",
     "spec/doc_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.3.4"])
      s.add_runtime_dependency(%q<bcrypt-ruby>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<hpricot>, [">= 0.8.1"])
      s.add_runtime_dependency(%q<htmlentities>, [">= 4.2.0"])
      s.add_runtime_dependency(%q<json>, [">= 1.2.3"])
      s.add_runtime_dependency(%q<push-notify>, [">= 0.1.0"])
      s.add_runtime_dependency(%q<rack>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<rack-cache>, [">= 0.5.2"])
      s.add_runtime_dependency(%q<rack-throttle>, [">= 0.3.0"])
      s.add_runtime_dependency(%q<sqlite3-ruby>, [">= 1.2.1"])
      s.add_runtime_dependency(%q<tinyatom>, [">= 0.1.1"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.3.4"])
      s.add_dependency(%q<bcrypt-ruby>, [">= 2.1.2"])
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<hpricot>, [">= 0.8.1"])
      s.add_dependency(%q<htmlentities>, [">= 4.2.0"])
      s.add_dependency(%q<json>, [">= 1.2.3"])
      s.add_dependency(%q<push-notify>, [">= 0.1.0"])
      s.add_dependency(%q<rack>, [">= 1.0.0"])
      s.add_dependency(%q<rack-cache>, [">= 0.5.2"])
      s.add_dependency(%q<rack-throttle>, [">= 0.3.0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 1.2.1"])
      s.add_dependency(%q<tinyatom>, [">= 0.1.1"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.3.4"])
    s.add_dependency(%q<bcrypt-ruby>, [">= 2.1.2"])
    s.add_dependency(%q<builder>, [">= 2.1.2"])
    s.add_dependency(%q<hpricot>, [">= 0.8.1"])
    s.add_dependency(%q<htmlentities>, [">= 4.2.0"])
    s.add_dependency(%q<json>, [">= 1.2.3"])
    s.add_dependency(%q<push-notify>, [">= 0.1.0"])
    s.add_dependency(%q<rack>, [">= 1.0.0"])
    s.add_dependency(%q<rack-cache>, [">= 0.5.2"])
    s.add_dependency(%q<rack-throttle>, [">= 0.3.0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 1.2.1"])
    s.add_dependency(%q<tinyatom>, [">= 0.1.1"])
  end
end

