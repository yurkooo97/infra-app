#!/bin/bash
          if [ $(sudo docker ps -q | wc -l) -gt 0 ]; then
            sudo docker stop $(sudo docker ps -q)
            sudo docker rm $(sudo docker ps -a -q)
            sudo docker system prune -a -f
          fi
