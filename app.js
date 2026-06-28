const express    = require('express');
const session    = require('express-session');
const http       = require('http');
const { Server } = require('socket.io');
const path       = require('path');
const db         = require('./config/db');

const app    = express();
const server = http.createServer(app);
const io     = new Server(server, { cors: { origin: '*' } });

// Middleware
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));
app.use(session({
  secret: 'taskflow_secret_2024',
  resave: false,
  saveUninitialized: false,
  cookie: { maxAge: 7 * 24 * 60 * 60 * 1000 }
}));

// Routes
app.use('/api/auth',     require('./routes/auth'));
app.use('/api/projects', require('./routes/projects'));
app.use('/api/tasks',    require('./routes/tasks'));

// Page routes
app.get('/',          (req, res) => res.redirect('/login'));
app.get('/login',     (req, res) => res.sendFile(path.join(__dirname, 'views/login.html')));
app.get('/register',  (req, res) => res.sendFile(path.join(__dirname, 'views/register.html')));
app.get('/dashboard', (req, res) => res.sendFile(path.join(__dirname, 'views/dashboard.html')));
app.get('/board',     (req, res) => res.sendFile(path.join(__dirname, 'views/board.html')));

// Socket.IO - Real-time
const userSockets = {};

io.on('connection', (socket) => {
  socket.on('join', (userId) => {
    userSockets[userId] = socket.id;
    socket.join(`user_${userId}`);
  });

  socket.on('join_project', (projectId) => {
    socket.join(`project_${projectId}`);
  });

  socket.on('task_moved', (data) => {
    socket.to(`project_${data.projectId}`).emit('task_updated', data);
  });

  socket.on('task_created', (data) => {
    socket.to(`project_${data.projectId}`).emit('task_new', data);
  });

  socket.on('comment_added', (data) => {
    socket.to(`project_${data.projectId}`).emit('comment_new', data);
  });

  socket.on('disconnect', () => {
    Object.keys(userSockets).forEach(uid => {
      if (userSockets[uid] === socket.id) delete userSockets[uid];
    });
  });
});

// Make io available to routes
app.set('io', io);

// Start server
const PORT = 5000;
server.listen(PORT, async () => {
  try {
    await db.query('SELECT 1');
    console.log(`✅ TaskFlow server running: http://localhost:${PORT}`);
    console.log(`✅ Database connected successfully`);
    console.log(`✅ WebSockets (Socket.IO) active`);
  } catch (e) {
    console.log(`✅ Server running at: http://localhost:${PORT}`);
    console.log(`❌ Database error: ${e.message}`);
  }
});
