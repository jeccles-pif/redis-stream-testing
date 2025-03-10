#!/bin/bash
# This script tests Redis Streams as a backend for eventing.
# It assumes Redis is running on host 'redis' and port 6379.

# 1. Add a message to the stream "mystream"
echo "Adding a message to mystream..."
# Quoting '*' prevents shell expansion so Redis receives the correct auto-ID indicator.
MESSAGE_ID=$(redis-cli -h redis -p 6379 --raw XADD mystream '*' event "user_signup" user "Alice")
echo "Message added with ID: $MESSAGE_ID"
echo

# 2. Read messages from "mystream" starting from the beginning (ID 0)
echo "Reading messages from mystream (from ID 0)..."
redis-cli -h redis -p 6379 XREAD COUNT 10 STREAMS mystream 0
echo

# 3. Create a consumer group named "mygroup" for "mystream"
echo "Creating consumer group 'mygroup' for mystream..."
redis-cli -h redis -p 6379 XGROUP CREATE mystream mygroup '$' MKSTREAM
echo

# 4. Read messages as a consumer from the group "mygroup"
echo "Reading messages as consumer 'consumer1' (only new messages)..."
redis-cli -h redis -p 6379 XREADGROUP GROUP mygroup consumer1 COUNT 10 STREAMS mystream '>'
echo

# 5. Acknowledge the previously added message using its ID, if valid
if [[ "$MESSAGE_ID" =~ ^[0-9]+-[0-9]+$ ]]; then
  echo "Acknowledging message with ID: $MESSAGE_ID"
  redis-cli -h redis -p 6379 XACK mystream mygroup "$MESSAGE_ID"
else
  echo "Invalid message ID captured: $MESSAGE_ID, skipping acknowledgement."
fi
echo

# 6. View pending messages for the consumer group "mygroup"
echo "Viewing pending messages for consumer group 'mygroup'..."
redis-cli -h redis -p 6379 XPENDING mystream mygroup
echo

echo "Redis Streams test complete."
