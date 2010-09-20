require 'socket'

port = ARGV.first || "44444"

TCPServer.open('localhost',port) do |s|
  STDERR.puts "Listening with #{port} ..."
  is_looping = true
  while is_looping
    cl = s.accept
    p cl.peeraddr
    unless cl.peeraddr[3] == "127.0.0.1"
      cl.close
    else
      Thread.start {
        data = cl.gets.chomp
        is_looping = false if data == "end"
        STDERR.puts "receive data: #{data}"
        cl.print data
        cl.close
      }
    end
  end
  Thread.list.each{|t| Thread.kill(t) unless t == Thread.current}
  puts "...End"
end
