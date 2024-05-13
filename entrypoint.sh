#!/bin/bash

# Optional: Wait explicitly or perform pre-start tasks
sleep 20
echo "Running migrations..."
sqlx migrate run

echo "Starting the main application..."
exec ./soccer-meet-youtube
