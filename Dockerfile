# ---------- Build React ----------
FROM node:18 AS frontend

WORKDIR /app/frontend

COPY TODO/todo_frontend/package*.json ./
RUN npm install

COPY TODO/todo_frontend .
RUN npm run build


# ---------- Backend ----------
FROM node:18-alpine

WORKDIR /app

COPY TODO/todo_backend/package*.json ./
RUN npm install --production

COPY TODO/todo_backend .

# Copy React build to backend
COPY --from=frontend /app/frontend/build ./build

EXPOSE 5000

CMD ["node", "index.js"]