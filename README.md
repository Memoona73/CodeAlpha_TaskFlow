# ◈ TaskFlow — Project Management Tool

A full-stack collaborative project management tool like Trello/Asana.

## Features
- ✅ User Authentication (Register/Login)
- ✅ Create & manage group projects
- ✅ Kanban board with drag-and-drop (To Do / In Progress / Done)
- ✅ Task cards with priority, due date, assignment
- ✅ Comment and communicate within tasks
- ✅ Add team members to projects
- ✅ Real-time updates via WebSockets (Socket.IO)
- ✅ Notification system
- ✅ Project progress tracking

## Setup Instructions

### 1. Install XAMPP & Start Apache + MySQL

### 2. Create Database
- Open: http://localhost/phpmyadmin
- Click "New" → Name: `taskflow_db` → Create
- Click Import → Choose `taskflow_database.sql` → Go

### 3. Install & Run
```
cd taskflow
npm install
node app.js
```

### 4. Open
http://localhost:5000

### Demo Login
- Email: ayesha@demo.com / Password: password
- Email: ali@demo.com / Password: password

## Tech Stack
- Node.js + Express
- MySQL (mysql2)
- Socket.IO (real-time)
- bcryptjs (auth)
- Vanilla HTML/CSS/JS (frontend)
- DM Sans + Syne fonts
