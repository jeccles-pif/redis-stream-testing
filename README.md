# redis-stream-testing
This is a repository to test if I can get redis streams working.  I think it works out of the box. 

How to make it work:

Use codespaces - launching codespaces should make it build correctly, but if not, Open the Command Palette (Ctrl+Shift+P or Cmd+Shift+P) and run the command "Rebuild Container" (or "Rebuild Codespace").  

Start redis with redis-cli -h redis -p 6379 (it's on port 6379 but you can change that in the code). 

You can also run the bash file from the terminal - chmod +x test_redis_stream.sh && ./test_redis_stream.sh

Some sample stream commands:

# Add an entry to a stream named "mystream"
XADD mystream * field1 value1

# Read all entries in the stream
XRANGE mystream - +
