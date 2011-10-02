$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'cgi'
require 'digest/md5'
require 'net/http'
require 'logger'
require 'open-uri'
require 'pp'
require 'set'
require 'uri'
require 'yaml'

require 'active_record'
require 'RMagick'

require 'murlsh'

def gem_not_found(gem_name)
  puts "#{gem_name} gem not found"
end

config = YAML.load_file('config.yaml')

# for Heroku
if ENV['DATABASE_URL']
  db_parsed = URI(ENV['DATABASE_URL'])

  config['db'] = {
    :adapter =>
      db_parsed.scheme == 'postgres' ? 'postgresql' : db_parsed.scheme,
    :host => db_parsed.host,
    :username => db_parsed.user,
    :password => db_parsed.password,
    :database => db_parsed.path[1..-1],
  )
end

heroku_info = {}

# Wrapper for database connection and cleanup from a Rake task.
def use_db(db_config)
  ActiveRecord::Base.establish_connection db_config
  yield
ensure
  ActiveRecord::Base.clear_active_connections!
end

desc 'Initialize a new installation.'
task :init => %w{db:migrate user:add compress} do
  puts <<-eos

Things you might want to do now:

- visit #{config['root_url']} in a browser
- 'rake post_sh > url_post.sh' to generate a shell script for posting urls

eos
end

desc 'Combine and compress static files.'
task :compress => %w{css:compress js:compress}

desc 'Test remote content type fetch for a URL and show errors.'
task :content_type, :url do |t, args|
  puts URI(args.url).extend(Murlsh::UriAsk).content_type(:failproof => false,
    :debug => STDOUT)
end

namespace :db do

  desc 'Delete a url from the database.'
  task :delete_url, :url_id, :force do |t,args|
    use_db(config.fetch('db')) {
      url_to_delete = unless args.url_id.to_s.empty?
        Murlsh::Url.find(args.url_id)
      else
        puts 'No id specified, defaulting to most recently added url.'
        Murlsh::Url.find(:last, :order => 'time')
      end

      pp url_to_delete

      if args.force == 'force'
        url_to_delete.destroy
      else
        response = Murlsh.ask('Delete this url?', 'n')
        url_to_delete.destroy  if %w{y yes}.include?(response.downcase)
      end
    }
  end

  desc 'Check for duplicate URLs.'
  task :dupcheck do
    h = {}
    use_db(config.fetch('db')) {
      Murlsh::Url.all.each do |mu|
        h[mu.url] = h.fetch(mu.url, []).push([mu.id, mu.time])
      end
    }
    h.find_all { |k,v| v.size > 1 }.each do |k,v|
      puts k
      v.each { |id,time| puts "  id #{id} (#{time})" }
    end
  end

  desc 'Migrate the database.'
  task :migrate do
    use_db(config.fetch('db')) {
      ActiveRecord::Base.logger = Logger.new($stdout)
      ActiveRecord::Migration.verbose = true
      ActiveRecord::Migrator.migrate 'db/migrate'
    }
  end

  desc 'Interact with the database.'
  task :shell do
    db = config.fetch('db')
    command = case db.fetch('adapter')
      when 'sqlite3'; "sqlite3 #{db.fetch('database')}"
    end

    if command
      exec command
    else
      puts "Don't know how to launch shell for database '#{db.fetch('adapter')}'"
    end
  end

  desc 'Search urls and titles in the database.'
  task :grep, :search do |t,args|
    like = "%#{args.search}%"
    use_db(config.fetch('db')) {
      Murlsh::Url.all(:conditions =>
        ['title LIKE ? OR url LIKE ?', like, like]).each do |url|
        puts "#{url.id} #{url.url} #{url.title}"
      end
    }
  end
end

directory 'tmp'

namespace :passenger do

  desc 'Restart Passenger.'
  task :restart => %w{compress tmp} do
    open('tmp/restart.txt', 'w') { |f| }
  end

end

desc 'Run flog on ruby and report on complexity.'
task :flog do
  begin
    require 'flog'

    flog = Flog.new
    flog.flog 'lib'
    flog.report
  rescue LoadError
    gem_not_found 'flog'
  end
end

desc 'Run test suite.'
begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new('test') do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = %w{--color}
    t.verbose = true
  end
rescue LoadError
  gem_not_found 'rspec'
end

desc 'Test remote title fetch for a URL and show errors.'
task :title, :url do |t, args|
  puts URI(args.url).extend(Murlsh::UriAsk).title(:failproof => false,
    :debug => STDOUT)
end

desc 'Try to fetch the title for a url and update it in the database.'
task :title_fetch, :url_id do |t, args|
  use_db(config.fetch('db')) {
    url = Murlsh::Url.find(args.url_id)
    puts "Url: #{url.url}"
    puts "Previous title: #{url.title}"
    url.title = URI(url.url).extend(Murlsh::UriAsk).title(:failproof => false)
    url.save
    puts "\nNew title: #{url.title}"
  }
end

namespace :user do

  desc 'Add a new user.'
  task :add do
    puts "adding to #{config.fetch('auth_file')}"
    username = Murlsh.ask('Username:')
    email = Murlsh.ask('Email:')
    password = Murlsh.ask('Password:')

    Murlsh::Auth.new(config.fetch('auth_file')).add_user(username, email,
      password)
  end

end

desc 'Generate code for a bookmarklet that will post a new url.'
task :post_bookmarklet do
  password = Murlsh.ask('Password:')
  password = CGI.escape(CGI.escape(password))
  puts <<EOS
javascript:var%20d=document,dgs=d.getSelection,enc=encodeURIComponent,w=window,wgs=w.getSelection,s=''+(wgs?wgs():dgs?dgs():d.selection.createRange().text);void(window.open('#{config.fetch('root_url')}bookmarklet?title='+enc(s)+'&url='+enc(location.href)+'&auth=#{password}'));
EOS
end

desc 'Generate a shell script that will post a new url (saved password optional).'
task :post_sh, :password do |t,args|
  puts <<EOS
#!/bin/sh

URL="$1"
VIA="$2"
AUTH="#{args.password || '$3'}"

curl \\
  --data-urlencode "url=${URL}" \\
  --data-urlencode "auth=${AUTH}" \\
  --data-urlencode "via=${VIA}" \\
  #{config.fetch('root_url')}
EOS
end

directory 'public/css'

namespace :css do

  desc 'Combine and compress css.'
  task :compress => ['public/css'] do
    combined = Murlsh.cat_files(
      config['css_files'].map { |x| "public/#{x}" }, "\n")

    md5sum = Digest::MD5.hexdigest(combined)

    filename = "#{md5sum}.gen.css"

    out = "public/css/#{filename}"

    open(out, 'w') { |f| f.write(combined) }
    puts "generated #{out}"

    compressed_url = "css/#{filename}"

    unless config['css_compressed'] == compressed_url
      config['css_compressed'] = compressed_url
      Murlsh.write_ordered_hash config, 'config.yaml'
      puts "updated config with css_compressed = #{compressed_url}"
    end
  end

end

directory 'public/js'

namespace :js do

  MURLSH_JS = %w{public/js/js.js}

  desc 'Combine and compress javascript.'
  task :compress => ['public/js'] do
    combined = Murlsh.cat_files(
      config['js_files'].map { |x| "public/#{x}" } )

    compressed = Net::HTTP.post_form(
      URI.parse('http://closure-compiler.appspot.com/compile'), {
      'compilation_level' => 'SIMPLE_OPTIMIZATIONS',
      'js_code' => combined,
      'output_format' => 'text',
      'output_info' => 'compiled_code',
      }).body

    md5sum = Digest::MD5.hexdigest(compressed)

    filename = "#{md5sum}.gen.js"

    out = "public/js/#{filename}"

    open(out, 'w') { |f| f.write(compressed) }
    puts "generated #{out}"

    compressed_url = "js/#{filename}"

    unless config['js_compressed'] == compressed_url
      config['js_compressed'] = compressed_url
      Murlsh.write_ordered_hash config, 'config.yaml'
      puts "updated config with js_compressed = #{compressed_url}"
    end
  end

  desc 'Run javascript through jslint.'
  task :jslint do
    local_jslint = 'jslint_rhino.js'
    open(local_jslint, 'w') do |f|
      f.write(Murlsh.cat_files(%w{
        https://github.com/AndyStricker/JSLint/raw/rhinocmdline/fulljslint.js
        https://github.com/AndyStricker/JSLint/raw/rhinocmdline/rhino.js
      }))
    end

    MURLSH_JS.each do |jsf|
      puts jsf
      puts `rhino #{local_jslint} #{jsf}`
    end
  end

  desc "Run javascript through Google's Closure Linter."
  task :gjslint do
    MURLSH_JS.each do |jsf|
      puts jsf
      puts `gjslint #{jsf}`
    end
  end

end

namespace :thumb do

  desc 'Check that local thumbnails in database are consistent with filesystem.'
  task :check do
    used_thumbnails = Set.new
    use_db(config.fetch('db')) {
      Murlsh::Url.all(
        :conditions => "thumbnail_url LIKE 'img/thumb/%'").each do |u|
        identity = "url #{u.id} (#{u.url})"

        path = File.join(%w{public}.concat(File.split(u.thumbnail_url)))
        used_thumbnails.add(path)
        if File.readable?(path)
          img_data = open(path) { |f| f.read }

          unless img_data.empty?
            img = Magick::ImageList.new.from_blob(img_data).extend(
              Murlsh::ImageList)

            ext = File.extname(path)
            expected_ext = img.preferred_extension
            if ext != expected_ext
              puts "#{identity} thumbnail #{path} has an extension of '#{ext}' but is actually a '#{expected_ext}'"
            end

            md5 = Digest::MD5.hexdigest(img_data)
            if File.basename(path, ext) != md5
              puts "#{identity} thumbnail #{path} filename does not match file content md5 (#{md5})"
            end
          else
            puts "#{identity} thumbnail #{path} is empty"
          end
        else
          puts "#{identity} thumbnail #{path} does not exist or is not readable"
        end
      end
    }
    # check if all thumbnail files that exist are in the database
    (Dir['public/img/thumb/*'] - used_thumbnails.to_a).each do |t|
      puts "thumbnail #{t} is not used"
    end
  end

end

namespace :import do

  desc 'Convert a delicious xml export into an import shell script.'
  task :delicious, :source do |t, args|
    puts <<EOS
#!/bin/sh

# murlsh import, source #{args.source}

PASSWORD="$1"
if [ -z "${PASSWORD}" ] ; then
    echo 'Password not set, pass as command line argument or hardcode in script'
    exit 1
fi

SITE_URL='#{config.fetch('root_url')}'

EOS
    Murlsh.delicious_parse(args.source) do |b|
      # escape single quotes because these will be in single quotes in output
      href_escaped = b[:href].to_s.gsub("'", "'\"'\"'")
      via_url_escaped = b[:via_url].to_s.gsub("'", "'\"'\"'")
      puts <<EOS
curl --data-urlencode 'url=#{href_escaped}' --data-urlencode "auth=${PASSWORD}" --data-urlencode 'via=#{via_url_escaped}' --data-urlencode 'time=#{b[:time].to_i}' ${SITE_URL}
EOS
    end
  end

end

desc 'Set options in config.yaml.'
task :config, :key, :value do |t, args|
  orig_value = config[args.key]
  if args.value != orig_value
    config[args.key] = args.value
    Murlsh.write_ordered_hash config, 'config.yaml'
    puts "updated '#{args.key}' '#{orig_value}' => '#{args.value}'"
  else
    puts "'#{args.key}' is already set to '#{args.value}'"
  end
end

namespace :app do

  desc 'Generate a bundler Gemfile for a murlsh instance.'
  task :gemfile => %w{heroku:info} do
    open('Gemfile', 'w') do |f|
      f.write <<EOS
# generated by 'rake app:gemfile'

source :rubygems

gem 'murlsh', '= #{Murlsh::VERSION}'

#{heroku_info.empty? ? '' : "gem 'pg'"}
EOS
    end
  end

end

namespace :heroku do

  desc 'Get Heroku info.'
  task :info do
    output = `heroku info -r 2>/dev/null`
    if $?.exitstatus == 0
      puts 'Heroku detected'
      heroku_info = Hash[output.split($/).map { |line| line.split('=', 2) }]
    end
  end

  desc 'Set config options for deployment on Heroku.'
  task :config => %w{compress info} do
    config.delete 'cache_entitystore'
    config.delete 'cache_metastore'
    puts 'removed cache_entitystore and cache_metastore from config, Rack::Cache disabled'

    if heroku_url = heroku_info['web_url']
      config['root_url'] = heroku_url
      puts "Set root_url to #{config['root_url']}"
    end

    Murlsh.write_ordered_hash config, 'config.yaml'
  end

end
