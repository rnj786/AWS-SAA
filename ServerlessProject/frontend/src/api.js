const API_URL = process.env.REACT_APP_API_URL;

export async function listFiles() {
  const resp = await fetch(`${API_URL}/files`);
  const data = await resp.json();
  // If files is an array of strings, convert to array of objects with dummy size/lastModified
  if (Array.isArray(data.files) && typeof data.files[0] === 'string') {
    return {
      files: data.files.map(f => ({
        key: f,
        size: '-',
        lastModified: '-'
      }))
    };
  }
  return data;
}

export async function uploadFile(file) {
  const formData = new FormData();
  formData.append('file', file);
  // Add filename as query param
  const filename = encodeURIComponent(file.name);
  return fetch(`${API_URL}/files?filename=${filename}`, {
    method: 'POST',
    body: formData,
  });
}

export async function deleteFiles(fileKeys) {
  // If only one file, pass as single filename param
  if (fileKeys.length === 1) {
    const filename = encodeURIComponent(fileKeys[0]);
    return fetch(`${API_URL}/files?filename=${filename}`, {
      method: 'DELETE',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ files: fileKeys }),
    });
  } else {
    // For multiple files, pass all as repeated query params (or just use body as before)
    const query = fileKeys.map(f => `filename=${encodeURIComponent(f)}`).join('&');
    return fetch(`${API_URL}/files?${query}`, {
      method: 'DELETE',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ files: fileKeys }),
    });
  }
}
