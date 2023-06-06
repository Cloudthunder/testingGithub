# Builder
from golang:1.20 as builder

workdir /go/build

copy go.mod go.sum ./
run go mod download
copy . .
run go build -o app

# Runner
from debian:11.6

workdir /app

env tz="Asia/Taipei"
run apt-get update && apt-get install -y ca-certificates
#run apk add --no-cache tzdata

copy lib/libfwlib32-linux-x64.so.1.0.5 /usr/lib/
run ln -s lib/libfwlib32-linux-x64.so.1.0.5 /usr/lib/libfwlib32.so
run ldconfig

copy --from=builder /go/build/app ./

cmd ["./app"]
