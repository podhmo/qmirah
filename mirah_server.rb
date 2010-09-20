require 'socket'
begin
  require 'mirah'
rescue LoadError
  $: << File.dirname(__FILE__)+"/workarea/mirah/lib"
  require 'mirah'
end

## monkey patching
class DubyImpl
  def exit(n)
    raise "exit with status #{n}"
  end
end

duby = DubyImpl.new

def duby.doaction(str)
  cmd, *args = str.split(" ")
  begin
    send(cmd.to_sym, *args)
  rescue NoMethodError
    send(:print_help)
  end
end

require 'socket'
def with_server(name,port)
  TCPServer.open(name,port) do |s|
    STDERR.puts "Listening with #{port} ..."
    yield(s)
    Thread.list.each{|t| Thread.kill(t) unless t == Thread.current}
    STDERR.puts "...End"
  end
end

with_server('localhost', "44444") do |s|
  loop do
    Thread.start(s.accept) do |cl|
      duby.doaction cl.gets.chomp.tap{|e| STDERR.puts "recv: #{e}"}
      cl.close
    end
  end
end


