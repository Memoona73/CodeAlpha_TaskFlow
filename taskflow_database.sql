-- TaskFlow Database
CREATE DATABASE IF NOT EXISTS taskflow_db;
USE taskflow_db;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  avatar_color VARCHAR(20) DEFAULT '#6366f1',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS projects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  color VARCHAR(20) DEFAULT '#10b981',
  owner_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS project_members (
  id INT AUTO_INCREMENT PRIMARY KEY,
  project_id INT NOT NULL,
  user_id INT NOT NULL,
  role ENUM('owner','member') DEFAULT 'member',
  joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_member (project_id, user_id),
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  project_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  status ENUM('todo','inprogress','done') DEFAULT 'todo',
  priority ENUM('low','medium','high') DEFAULT 'medium',
  assigned_to INT,
  created_by INT NOT NULL,
  due_date DATE,
  position INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS task_comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  task_id INT NOT NULL,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  message VARCHAR(300) NOT NULL,
  type VARCHAR(50) DEFAULT 'info',
  is_read TINYINT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Demo data
INSERT INTO users (full_name, username, email, password) VALUES
('Ayesha Khan', 'ayesha_k', 'ayesha@demo.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'),
('Ali Hassan', 'ali_h', 'ali@demo.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

INSERT INTO projects (name, description, color, owner_id) VALUES
('Website Redesign', 'Redesign the company website with modern UI', '#10b981', 1),
('Mobile App', 'Build iOS and Android app for clients', '#6366f1', 1);

INSERT INTO project_members (project_id, user_id, role) VALUES
(1, 1, 'owner'), (1, 2, 'member'),
(2, 1, 'owner'), (2, 2, 'member');

INSERT INTO tasks (project_id, title, description, status, priority, assigned_to, created_by, position) VALUES
(1, 'Design new homepage', 'Create wireframes and mockups for homepage', 'todo', 'high', 1, 1, 1),
(1, 'Set up project repo', 'Initialize GitHub repository with CI/CD', 'inprogress', 'medium', 2, 1, 1),
(1, 'Write API docs', 'Document all REST endpoints', 'done', 'low', 1, 1, 1),
(2, 'User authentication', 'Implement login/register with JWT', 'todo', 'high', 2, 1, 1),
(2, 'Push notifications', 'Integrate Firebase push notifications', 'inprogress', 'medium', 1, 1, 1);
