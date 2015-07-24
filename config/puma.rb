#!/usr/bin/env puma

environment 'production'
daemonize true
pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'
bind 'unix://tmp/sockets/puma.sock'
