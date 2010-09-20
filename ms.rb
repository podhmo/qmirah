require 'socket'
begin
  require 'mirah'
rescue LoadError
  $: << File.dirname(__FILE__)+"/workarea/mirah/lib"
  require 'mirah'
end

port = ARGV.first || "44444"
duby = DubyImpl.new

# duby.send("compile".to_sym, "-j", "fib.mirah")
# __END__

def duby.choice_cmd(cmd)
  if cmd == "compile" || cmd == "run"
    cmd.to_sym
  else
    :show_candidates
  end
end

def duby.show_candidates(*args)
  puts "args = #{args}"
  puts "\t{compile,run} arg0 arg1 ..."
  print_help
end

def duby.doaction(client_sock, args)
  # out = $stdout.dup
  # $stdout = client_sock
  unless args.length >= 2
    show_candidates
  else
    cmd, *args = args
    #send(choice_cmd(cmd) *args)
    compile(*args)
    #send(:compile, *args)
  end
  # $stdout = out
end

TCPServer.open('localhost',port) do |s|
  STDERR.puts "Listening with #{port} ..."
  loop do
    cl = s.accept
    Thread.start do
      p args = cl.gets.chomp.split(" ")
      begin
        duby.doaction(cl,args)
      rescue Exceptionnn
        puts [$!,$@]
      end
      cl.close
    end
  end
  Thread.list.each{|t| Thread.kill(t) unless t == Thread.current}
  puts "...End"
end
