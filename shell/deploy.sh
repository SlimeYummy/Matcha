#!/bin/sh

#
# Usage:
#   ./shell/deploy.sh [user@host] [port]
#
# Example:
#   ./shell/deploy.sh user@domain.com 22
#

# npm run release
ssh -p $2 $1 "ps -A | grep node | awk '{print \$1}' | xargs kill -TERM"
ssh -p $2 $1 'rm ~/FenQi.IO/Matcha-Node/* ~/FenQi.IO/Matcha-Web/*'
scp -P $2 ./prod/server* $1:~/FenQi.IO/Matcha-Node/
scp -P $2 ./prod/client* $1:~/FenQi.IO/Matcha-Web/
ssh -p $2 $1 ' cd ~/FenQi.IO && ./start.sh'
