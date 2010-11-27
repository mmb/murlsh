# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{murlsh}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew M. Boedicker"]
  s.date = %q{2010-11-27}
  s.default_executable = %q{murlsh}
  s.description = %q{url sharing site framework with easy adding, title lookup, atom feed, thumbnails and embedding}
  s.email = %q{matthewm@boedicker.org}
  s.executables = ["murlsh"]
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
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
    "lib/murlsh/build_query.rb",
    "lib/murlsh/config_server.rb",
    "lib/murlsh/dispatch.rb",
    "lib/murlsh/doc.rb",
    "lib/murlsh/etag_add_encoding.rb",
    "lib/murlsh/failproof.rb",
    "lib/murlsh/far_future_expires.rb",
    "lib/murlsh/head_from_get.rb",
    "lib/murlsh/image_list.rb",
    "lib/murlsh/img_store.rb",
    "lib/murlsh/markup.rb",
    "lib/murlsh/must_revalidate.rb",
    "lib/murlsh/openlock.rb",
    "lib/murlsh/plugin.rb",
    "lib/murlsh/sqlite3_adapter.rb",
    "lib/murlsh/time_ago.rb",
    "lib/murlsh/uri_ask.rb",
    "lib/murlsh/uri_domain.rb",
    "lib/murlsh/uri_get_path_query.rb",
    "lib/murlsh/url.rb",
    "lib/murlsh/url_body.rb",
    "lib/murlsh/url_server.rb",
    "lib/murlsh/yaml_ordered_hash.rb",
    "murlsh.gemspec",
    "plugins/add_post_50_update_feed.rb",
    "plugins/add_post_50_update_podcast.rb",
    "plugins/add_post_50_update_rss.rb",
    "plugins/add_post_60_notify_hubs.rb",
    "plugins/add_pre_40_convert_mobile.rb",
    "plugins/add_pre_50_lookup_content_type_title.rb",
    "plugins/add_pre_60_flickr.rb",
    "plugins/add_pre_60_github_title.rb",
    "plugins/add_pre_60_google_code_title.rb",
    "plugins/add_pre_60_imgur.rb",
    "plugins/add_pre_60_s3_image.rb",
    "plugins/add_pre_60_twitter.rb",
    "plugins/add_pre_60_vimeo.rb",
    "plugins/add_pre_60_youtube.rb",
    "plugins/add_pre_65_html_thumb.rb",
    "plugins/add_pre_65_img_thumb.rb",
    "plugins/avatar_50_gravatar.rb",
    "plugins/html_parse_50_nokogiri.rb",
    "plugins/url_display_add_45_audio.rb",
    "plugins/url_display_add_50_hostrec.rb",
    "plugins/url_display_add_55_content_type.rb",
    "plugins/url_display_add_60_via.rb",
    "plugins/url_display_add_65_time.rb",
    "public/css/jquery.jgrowl.css",
    "public/css/screen.css",
    "public/img/thumb/.gitignore",
    "public/js/comments.json",
    "public/js/jquery-1.4.4.min.js",
    "public/js/jquery.jgrowl_compressed.js",
    "public/js/js.js",
    "public/js/twitter-text-1.0.4.js",
    "spec/auth_spec.rb",
    "spec/dispatch_spec.rb",
    "spec/doc_spec.rb",
    "spec/img_store_spec.rb",
    "spec/markup_spec.rb",
    "spec/uri_ask_spec.rb",
    "spec/uri_domain_spec.rb",
    "spec/url_spec.rb",
    "spec/yaml_ordered_hash_spec.rb"
  ]
  s.homepage = %q{http://github.com/mmb/murlsh}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{url sharing site framework}
  s.test_files = [
    "spec/auth_spec.rb",
    "spec/dispatch_spec.rb",
    "spec/doc_spec.rb",
    "spec/img_store_spec.rb",
    "spec/markup_spec.rb",
    "spec/uri_ask_spec.rb",
    "spec/uri_domain_spec.rb",
    "spec/url_spec.rb",
    "spec/yaml_ordered_hash_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.3.4"])
      s.add_runtime_dependency(%q<bcrypt-ruby>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<flickraw>, [">= 0.8.3"])
      s.add_runtime_dependency(%q<htmlentities>, [">= 4.2.0"])
      s.add_runtime_dependency(%q<json>, [">= 1.2.3"])
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.0"])
      s.add_runtime_dependency(%q<plumnailer>, [">= 0.1.0"])
      s.add_runtime_dependency(%q<public_suffix_service>, ["~> 0.0"])
      s.add_runtime_dependency(%q<push-notify>, [">= 0.1.0"])
      s.add_runtime_dependency(%q<rack>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<rack-cache>, [">= 0.5.2"])
      s.add_runtime_dependency(%q<rack-rewrite>, [">= 1.0.2"])
      s.add_runtime_dependency(%q<rack-throttle>, [">= 0.3.0"])
      s.add_runtime_dependency(%q<rmagick>, [">= 1.15.14"])
      s.add_runtime_dependency(%q<sqlite3-ruby>, [">= 1.2.1"])
      s.add_runtime_dependency(%q<tinyatom>, [">= 0.3.3"])
      s.add_runtime_dependency(%q<twitter>, [">= 0.9.12"])
      s.add_runtime_dependency(%q<vimeo>, [">= 1.2.2"])
      s.add_development_dependency(%q<flog>, [">= 2.5.0"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.3.4"])
      s.add_dependency(%q<bcrypt-ruby>, [">= 2.1.2"])
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<flickraw>, [">= 0.8.3"])
      s.add_dependency(%q<htmlentities>, [">= 4.2.0"])
      s.add_dependency(%q<json>, [">= 1.2.3"])
      s.add_dependency(%q<nokogiri>, ["~> 1.0"])
      s.add_dependency(%q<plumnailer>, [">= 0.1.0"])
      s.add_dependency(%q<public_suffix_service>, ["~> 0.0"])
      s.add_dependency(%q<push-notify>, [">= 0.1.0"])
      s.add_dependency(%q<rack>, [">= 1.0.0"])
      s.add_dependency(%q<rack-cache>, [">= 0.5.2"])
      s.add_dependency(%q<rack-rewrite>, [">= 1.0.2"])
      s.add_dependency(%q<rack-throttle>, [">= 0.3.0"])
      s.add_dependency(%q<rmagick>, [">= 1.15.14"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 1.2.1"])
      s.add_dependency(%q<tinyatom>, [">= 0.3.3"])
      s.add_dependency(%q<twitter>, [">= 0.9.12"])
      s.add_dependency(%q<vimeo>, [">= 1.2.2"])
      s.add_dependency(%q<flog>, [">= 2.5.0"])
      s.add_dependency(%q<rspec>, ["~> 1.3"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.3.4"])
    s.add_dependency(%q<bcrypt-ruby>, [">= 2.1.2"])
    s.add_dependency(%q<builder>, [">= 2.1.2"])
    s.add_dependency(%q<flickraw>, [">= 0.8.3"])
    s.add_dependency(%q<htmlentities>, [">= 4.2.0"])
    s.add_dependency(%q<json>, [">= 1.2.3"])
    s.add_dependency(%q<nokogiri>, ["~> 1.0"])
    s.add_dependency(%q<plumnailer>, [">= 0.1.0"])
    s.add_dependency(%q<public_suffix_service>, ["~> 0.0"])
    s.add_dependency(%q<push-notify>, [">= 0.1.0"])
    s.add_dependency(%q<rack>, [">= 1.0.0"])
    s.add_dependency(%q<rack-cache>, [">= 0.5.2"])
    s.add_dependency(%q<rack-rewrite>, [">= 1.0.2"])
    s.add_dependency(%q<rack-throttle>, [">= 0.3.0"])
    s.add_dependency(%q<rmagick>, [">= 1.15.14"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 1.2.1"])
    s.add_dependency(%q<tinyatom>, [">= 0.3.3"])
    s.add_dependency(%q<twitter>, [">= 0.9.12"])
    s.add_dependency(%q<vimeo>, [">= 1.2.2"])
    s.add_dependency(%q<flog>, [">= 2.5.0"])
    s.add_dependency(%q<rspec>, ["~> 1.3"])
  end
end

