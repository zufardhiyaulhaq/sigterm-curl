# SIGTERM-CURL
application that doing curl after receiving SIGTERM

### Usage
1. Run
```
make build
./bin/sigterm-curl
```

2. Exit
```
ps aux | grep sigterm-curl
kill -SIGTERM <pid>
```
