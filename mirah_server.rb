require 'socket'

def with_conf
  $conf ||= (require 'yaml'; YAML.load_file("setting.yaml"))
  yield($conf)
end

begin
  require 'mirah'
rescue LoadError
  with_conf do |conf|
    dir = conf["mirah_lib"] || File.dirname(__FILE__)+"/workarea/mirah/lib"
    $: << dir
  end
  require 'mirah'
end

class ExitException < StandardError; end
## monkey patching
class DubyImpl
  def exit(n)
    raise ExitException, "exit with status #{n}"
  end
end

module Duby
  def self.doaction(str)
    cmd, *args = str.split(" ")
    begin
      send(cmd.to_sym, *args)
    rescue NoMethodError
      DubyImpl.new.print_help
    rescue ExitException
    rescue
      puts [$!,$@]
    end
  end
end

def with_server(name,port)
  TCPServer.open(name,port) do |s|
    STDERR.puts "Listening with #{port} ..."
    yield(s)
    Thread.list.each{|t| Thread.kill(t) unless t == Thread.current}
    STDERR.puts "...End"
  end
end
port = ARGV.first || with_conf{|c| c["port"]}

with_server('localhost', port) do |s|
  loop do
    Thread.start(s.accept) do |cl|
      Duby.doaction cl.gets.chomp.tap{|e| STDERR.puts "recv: #{e}"}
      cl.close
    end
  end
end
