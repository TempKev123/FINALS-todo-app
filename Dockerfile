# syntax=docker/dockerfile:1
FROM node:18-alpine

# Install build dependencies for native modules like sqlite3
RUN apk add --no-cache python3 g++ make

WORKDIR /app

# Copy dependency files first (better Docker caching)
COPY package*.json ./

# Install production dependencies
RUN npm install --omit=dev

# Copy the rest of the application
COPY . .

# Expose the app port
EXPOSE 5000

# Start the application
CMD ["node", "index.js"]