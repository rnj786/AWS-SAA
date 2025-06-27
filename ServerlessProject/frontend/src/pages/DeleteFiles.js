import React, { useEffect, useState } from 'react';
import { listFiles, deleteFiles } from '../api';

function DeleteFiles() {
  const [files, setFiles] = useState([]);
  const [selected, setSelected] = useState([]);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [confirming, setConfirming] = useState(false);

  useEffect(() => {
    setLoading(true);
    listFiles()
      .then(data => setFiles(data.files || []))
      .catch(() => setError("Failed to load files."))
      .finally(() => setLoading(false));
  }, []);

  const handleCheck = (key) => {
    setSelected(selected =>
      selected.includes(key)
        ? selected.filter(k => k !== key)
        : [...selected, key]
    );
  };

  const handleDelete = async () => {
    setError("");
    setMessage("");
    setConfirming(false);
    setLoading(true);
    try {
      await deleteFiles(selected);
      setFiles(files.filter(f => !selected.includes(f.key)));
      setSelected([]);
      setMessage("Selected files deleted successfully.");
    } catch (err) {
      setError("Failed to delete files.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ maxWidth: 600, margin: '40px auto', background: '#fff', borderRadius: 8, boxShadow: '0 2px 8px #0001', padding: 32 }}>
      <h2 style={{ textAlign: 'center', marginBottom: 24 }}>Delete Files</h2>
      {message && <div style={{ color: 'green', marginBottom: 16 }}>{message}</div>}
      {error && <div style={{ color: 'red', marginBottom: 16 }}>{error}</div>}
      {loading ? (
        <div>Loading...</div>
      ) : files.length === 0 ? (
        <div style={{ textAlign: 'center', color: '#888' }}>No files found.</div>
      ) : (
        <table style={{ width: '100%', borderCollapse: 'collapse', marginBottom: 16 }}>
          <thead>
            <tr style={{ background: '#f5f5f5' }}>
              <th style={{ width: 40 }}></th>
              <th style={{ textAlign: 'left', padding: 8 }}>File Name</th>
              <th style={{ textAlign: 'right', padding: 8 }}>Size</th>
              <th style={{ textAlign: 'right', padding: 8 }}>Last Modified</th>
            </tr>
          </thead>
          <tbody>
            {files.map(f => (
              <tr key={f.key} style={{ borderBottom: '1px solid #eee' }}>
                <td style={{ textAlign: 'center' }}>
                  <input
                    type="checkbox"
                    checked={selected.includes(f.key)}
                    onChange={() => handleCheck(f.key)}
                  />
                </td>
                <td style={{ padding: 8 }}>{f.key}</td>
                <td style={{ textAlign: 'right', padding: 8 }}>{f.size || '-'}</td>
                <td style={{ textAlign: 'right', padding: 8 }}>{f.lastModified || '-'}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      <button
        onClick={() => setConfirming(true)}
        disabled={selected.length === 0 || loading}
        style={{
          background: selected.length === 0 || loading ? '#ccc' : '#e53935',
          color: '#fff',
          border: 'none',
          borderRadius: 4,
          padding: '10px 24px',
          fontWeight: 600,
          cursor: selected.length === 0 || loading ? 'not-allowed' : 'pointer',
          width: '100%',
          marginTop: 8
        }}
      >
        Delete Selected
      </button>
      {confirming && (
        <div style={{
          position: 'fixed', top: 0, left: 0, width: '100vw', height: '100vh',
          background: '#0008', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000
        }}>
          <div style={{ background: '#fff', padding: 32, borderRadius: 8, minWidth: 320, textAlign: 'center' }}>
            <h3>Confirm Deletion</h3>
            <p>Are you sure you want to delete {selected.length} file(s)? This action cannot be undone.</p>
            <button onClick={handleDelete} style={{ background: '#e53935', color: '#fff', border: 'none', borderRadius: 4, padding: '8px 20px', marginRight: 12 }}>Yes, Delete</button>
            <button onClick={() => setConfirming(false)} style={{ background: '#eee', color: '#333', border: 'none', borderRadius: 4, padding: '8px 20px' }}>Cancel</button>
          </div>
        </div>
      )}
    </div>
  );
}
export default DeleteFiles;
