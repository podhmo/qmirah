require 'socket'
begin
  require 'mirah'
rescue LoadError
  $: << File.dirname(__FILE__)+"/workarea/mirah/lib"
  require 'mirah'
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
TCPServer.open('localhost', "44444") do |s|
  cl = s.accept
  duby.doaction cl.gets.chomp
  cl.close
end
#duby.doaction(STDIN.gets.chomp)
#duby.send(:compile, "-j", "fib.mirah")
