require 'socket'

ip = ARGV[0]
port = ARGV[1]
$runningThread = nil
$threadRunning = nil
$socket = TCPSocket.new(ip,port)
$wantsToExit = false
#$pdata = "PDATA"
#$end = "END"

#Listening for incoming commands
#In einer Tabelle werden die Commands gespeichert

#def send(data)
#    $socket.write(data)
#end


def executeCommand(command)
    puts "COMMAND IST #{command}"
    IO.popen(command) do |pipe|
        while (line = pipe.gets)
            $socket.write(line)
            Kernel.puts line
        end
    end
end

def convertData(line)
    if line.start_with?("CMD")
        command = line[4..-1]
        #$socket.write($pdata)
        $runningThread = Thread.new do
            $threadRunning = true
            executeCommand(command)
        end
        #$socket.write($end)
        $threadRunning = false
        
    elsif line == 'STOP'
        if $threadRunning == true
            $runningThread.kill
            $threadRunning = false
            #send("END")
        end
    elsif line == 'EXIT'
        $wantsToExit = true
        exit()
    end
end


def receiveData
    $thread5 = Thread.new do
        loop do
            while (line = $socket.gets)
                $thread7 = Thread.new do
                    if line.strip && line.strip != ""
                        convertData(line)
                    end
                end
            end
        end
    end
end

receiveData


loop do
    if $wantsToExit == true
        Kernel.puts "Exiting..."
        exit()
        break
    end
end
socket.close