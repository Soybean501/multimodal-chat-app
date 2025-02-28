'use client';

import { useState } from 'react';
import apiClient from '@/utils/apiClient';

const ChatBox = () => {
  const [prompt, setPrompt] = useState('');
  const [response, setResponse] = useState('');

  const submitPrompt = async () => {
    const formData = new FormData();
    formData.append('prompt', prompt);

    try {
      const res = await apiClient.post('/chat', formData);
      setResponse(res.data.response_text);
    } catch (error) {
      console.error('API error:', error);
    }
  };

  return (
    <div style={{ marginTop: '1rem' }}>
      <h2>💬 Chat</h2>
      <input
        style={{ width: '300px', padding: '8px', marginRight: '10px' }}
        value={prompt}
        onChange={(e) => setPrompt(e.target.value)}
        placeholder="Enter your prompt..."
      />
      <button onClick={submitPrompt}>Send</button>
      <div style={{ marginTop: '1rem' }}>
        <strong>Response:</strong> {response}
      </div>
    </div>
  );
};

export default ChatBox;
