import React from 'react';
import { BrowserRouter as Router, Link, Routes, Route } from 'react-router-dom';
import ListFiles from './pages/ListFiles';
import UploadFile from './pages/UploadFile';
import DeleteFiles from './pages/DeleteFiles';
import './App.css';

function App() {
  return (
    <Router>
      <div className="app-container">
        <header className="app-header">
          <h1>AWS Skills Development Project</h1>
        </header>
        <nav className="nav-grid">
          <Link to="/" className="nav-link">List Files</Link>
          <Link to="/upload" className="nav-link">Upload File</Link>
          <Link to="/delete" className="nav-link">Delete Files</Link>
        </nav>
        <main className="main-content">
          <Routes>
            <Route path="/" element={<ListFiles />} />
            <Route path="/upload" element={<UploadFile />} />
            <Route path="/delete" element={<DeleteFiles />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}
export default App;
