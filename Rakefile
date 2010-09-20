
desc "install"
task :install do
  require 'erb'
  require 'yaml'
  CONF = YAML.load_file("setting.yaml")

  make_file = lambda do |name,command|
    CONF["command"] = command
    File.open(name, "w") do |wf|
      wf.puts ERB.new(File.read("qmirah.erb")).result
    end
    File.chmod(0764, name)
  end
  
  make_file.call("qmirah","run")
  make_file.call("qmirahc","compile")
end

task :clean do
  sh "rm Fib*"
end
task :default => [:clean]
