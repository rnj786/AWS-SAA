import React, { useState } from 'react';
import { uploadFile } from '../api';
const API_URL = process.env.REACT_APP_API_URL;

function UploadFile() {
  const [file, setFile] = useState(null);
  const [message, setMessage] = useState("");
  const [uploading, setUploading] = useState(false);
  const [progress, setProgress] = useState(0);
  const [error, setError] = useState("");

  const handleUpload = async (e) => {
    e.preventDefault();
    setMessage("");
    setError("");
    setProgress(0);
    if (!file) return;
    setUploading(true);
    try {
      await uploadFileWithProgress(file, setProgress);
      setMessage("Upload successful!");
    } catch (err) {
      setError("Upload failed: " + (err.message || err));
    } finally {
      setUploading(false);
    }
  };

  // Custom upload with progress
  const uploadFileWithProgress = (file, onProgress) => {
    return new Promise((resolve, reject) => {
      const xhr = new XMLHttpRequest();
      const filename = encodeURIComponent(file.name);
      xhr.open('POST', `${API_URL}/files?filename=${filename}`);
      xhr.upload.onprogress = (event) => {
        if (event.lengthComputable) {
          onProgress(Math.round((event.loaded / event.total) * 100));
        }
      };
      xhr.onload = () => {
        if (xhr.status >= 200 && xhr.status < 300) {
          resolve(xhr.response);
        } else {
          reject(new Error(xhr.statusText || 'Upload failed'));
        }
      };
      xhr.onerror = () => reject(new Error('Network error'));
      xhr.ontimeout = () => reject(new Error('Request timed out'));
      const formData = new FormData();
      formData.append('file', file);
      xhr.send(formData);
    });
  };

  return (
    <div>
      <h2>Upload File</h2>
      <form onSubmit={handleUpload}>
        <input type="file" onChange={e => setFile(e.target.files[0])} />
        <button type="submit" disabled={uploading}>Upload</button>
      </form>
      {uploading && (
        <div style={{ margin: '1rem 0' }}>
          <div style={{ width: '100%', background: '#e5e7eb', borderRadius: '8px', height: '16px' }}>
            <div style={{ width: `${progress}%`, background: '#2563eb', height: '16px', borderRadius: '8px', transition: 'width 0.2s' }} />
          </div>
          <div style={{ textAlign: 'center', marginTop: 4 }}>{progress}%</div>
        </div>
      )}
      {message && <div style={{ color: 'green', marginTop: 8 }}>{message}</div>}
      {error && <div style={{ color: 'red', marginTop: 8 }}>{error}</div>}
    </div>
  );
}
export default UploadFile;
