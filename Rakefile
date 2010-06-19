require 'spec/rake/spectask'
require 'rake/classic_namespace'
require 'cucumber/rake/task'
 
task :default => [:spec, :features]
 
desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.spec_opts = ['--colour']
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "marcinbunsch-sinatras-hat"
    gemspec.summary = "Easy peasy CRUD with sinatra"
    gemspec.description = "Easy peasy CRUD with sinatra"
    gemspec.email = "marcin@applicake.com"
    gemspec.homepage = "http://github.com/marcinbunsch/sinatras-hat"
    gemspec.authors = ["Pat Nakajima", "Brad Phelan", "Marcin Bunsch" ]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

Cucumber::Rake::Task.new do |c|
  c.cucumber_opts = '--format progress'
end

namespace :sinatra do
  desc "Clone edge Sinatra"
  task :clone do
    vendor_dir = File.join(File.dirname(__FILE__), 'vendor')
    FileUtils.mkdir_p(vendor_dir)
    puts "* cloning git://github.com/rtomayko/sinatra.git"
    system("git clone git://github.com/rtomayko/sinatra.git #{File.expand_path(vendor_dir)}/sinatra")
    puts "* done."
  end
  
  desc "Update edge Sinatra"
  task :pull do
    sinatra_dir = File.join(File.dirname(__FILE__), 'vendor', 'sinatra')
    Task["sinatra:clone"].invoke unless File.exists?(sinatra_dir)
    
    puts "* pulling from git://github.com/rtomayko/sinatra.git"
    system("cd #{File.expand_path(sinatra_dir)} && git pull git://github.com/rtomayko/sinatra.git master")
    puts "* done."
  end 
  
  desc "Install edge Sinatra"
  task :install => :pull do
    sinatra_dir = File.join(File.dirname(__FILE__), 'vendor', 'sinatra')
    Task["sinatra:clone"].invoke unless File.exists?(sinatra_dir)
    puts "* installing edge sinatra"
    system("cd #{File.expand_path(sinatra_dir)} && rake install")
  end
end
