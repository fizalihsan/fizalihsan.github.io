require "rubygems"
require "bundler/setup"
require "stringex"

public_dir = "public"
deploy_dir = "../master_kshop"
deploy_branch = "master"

task "deploy" do
  puts "## Deploying branch to Github Pages "
  puts "## Pulling any updates from Github Pages "
  if !File.directory?(deploy_dir) then
     system "mkdir #{deploy_dir}"
  end

  cd "#{deploy_dir}" do 
    Bundler.with_clean_env { system "git pull" }
  end

  (Dir["#{deploy_dir}/*"]).each { |f| rm_rf(f) }
  # Rake::Task[:copydot].invoke(public_dir, deploy_dir)
  puts "\n## Copying #{public_dir} to #{deploy_dir}"

  cp_r "#{public_dir}/.", deploy_dir

  cd "#{deploy_dir}" do
    system "git add -A"
    message = "Site updated at #{Time.now.utc}"
    puts "\n## Committing: #{message}"
    system "git commit -m \"#{message}\""
    puts "\n## Pushing generated #{deploy_dir} website to branch '#{deploy_branch}'"
    Bundler.with_clean_env { system 'git push --set-upstream origin #{deploy_branch} --force' }
    puts "\n## Github Pages deploy complete"
  end
end