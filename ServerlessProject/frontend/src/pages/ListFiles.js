import React, { useEffect, useState } from 'react';
import { listFiles } from '../api';

function ListFiles() {
  const [files, setFiles] = useState([]);

  useEffect(() => {
    listFiles().then(data => setFiles(data.files || []));
  }, []);

  return (
    <div>
      <h2>Files</h2>
      <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr 1fr', gap: '1rem', alignItems: 'center', background: '#f3f4f6', borderRadius: '8px', padding: '1rem' }}>
        <div style={{ fontWeight: 'bold' }}>File Name</div>
        <div style={{ fontWeight: 'bold' }}>Size (bytes)</div>
        <div style={{ fontWeight: 'bold' }}>Last Modified</div>
        {files.map(f => (
          <React.Fragment key={f.key}>
            <div>{f.key}</div>
            <div>{f.size}</div>
            <div>{f.lastModified}</div>
          </React.Fragment>
        ))}
      </div>
    </div>
  );
}
export default ListFiles;
