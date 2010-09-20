require 'socket'
begin
  require 'mirah'
rescue LoadError
  $: << File.dirname(__FILE__)+"/workarea/mirah/lib"
  require 'mirah'
end

port = ARGV.first || "44444"
duby = DubyImpl.new

TCPServer.open('localhost',port) do |s|
  STDERR.puts "Listening with #{port} ..."
  is_looping = true
  while is_looping
    cl = s.accept
    Thread.start {
      data = cl.gets.chomp
      is_looping = false if data == "end"
      STDERR.puts "receive data: #{data}"
      cl.puts "receive args: #{data}"
      cl.close
      duby.compile(*data.split(" "))
    }
  end
  Thread.list.each{|t| Thread.kill(t) unless t == Thread.current}
  puts "...End"
end
