#!/bin/bash

curl -X POST http://localhost:3000/chat \
     -H "Content-Type: application/json" \
      -d '{
        "messages": [
          {
            "role": "user",
            "content": "Resuelve Fibonacci en JavaScript"
          }
        ]
      }'  
