#!/bin/bash

# Define frontend directory path
FRONTEND_DIR="./frontend"

echo "🏗️ Setting up functional frontend components and pages..."

# Ensure we're in project root
if [ ! -d "$FRONTEND_DIR/src" ]; then
  echo "❌ Frontend directory not found. Please run from your project's root folder."
  exit 1
fi

# 1. Update src/app/page.tsx (Next.js default page)
cat > $FRONTEND_DIR/src/app/page.tsx << 'EOF'
'use client';

import ChatBox from '@/components/ChatBox';
import AudioRecorder from '@/components/AudioRecorder';
import ScreenCapture from '@/components/ScreenCapture';
import ModelResponse from '@/components/ModelResponse';

export default function Home() {
  return (
    <main style={{ padding: '2rem', fontFamily: 'sans-serif' }}>
      <h1>Multimodal Chat App 🚀</h1>
      <ChatBox />
      <AudioRecorder />
      <ScreenCapture />
      <ModelResponse />
    </main>
  );
}
EOF

# 2. Update components/ChatBox.tsx (basic prompt & API call to backend)
cat > $FRONTEND_DIR/src/components/ChatBox.tsx << 'EOF'
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
EOF

# 3. Update components/AudioRecorder.tsx
cat > $FRONTEND_DIR/src/components/AudioRecorder.tsx << 'EOF'
'use client';

import { useState, useRef } from 'react';
import { captureMicrophone } from '@/utils/mediaUtils';

const AudioRecorder = () => {
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const audioChunksRef = useRef<Blob[]>([]);
  const [recording, setRecording] = useState(false);

  const startRecording = async () => {
    const stream = await captureMicrophone();
    if(stream) {
      mediaRecorderRef.current = new MediaRecorder(stream);
      mediaRecorderRef.current.start();
      setRecording(true);
      audioChunksRef.current = [];

      mediaRecorderRef.current.ondataavailable = (e) => {
        audioChunksRef.current.push(e.data);
      };
    }
  };

  const stopRecording = () => {
    mediaRecorderRef.current?.stop();
    setRecording(false);
    // TODO: Send audio to backend here
  };

  return (
    <div style={{ marginTop: '2rem' }}>
      <h2>🎙️ Audio Recorder</h2>
      <button onClick={recording ? stopRecording : startRecording}>
        {recording ? 'Stop' : 'Start'} Recording
      </button>
      <p>{recording ? 'Recording...' : 'Not recording'}</p>
    </div>
  );
};

export default AudioRecorder;
EOF

# 4. Update components/ScreenCapture.tsx
cat > $FRONTEND_DIR/src/components/ScreenCapture.tsx << 'EOF'
'use client';

import { useState, useRef } from 'react';
import { captureScreen } from '@/utils/mediaUtils';

const ScreenCapture = () => {
  const videoRef = useRef<HTMLVideoElement | null>(null);

  const startCapture = async () => {
    const stream = await captureScreen();
    if (stream && videoRef.current) {
      videoRef.current.srcObject = stream;
      videoRef.current.play();
      // TODO: Send video frames/images to backend here
    }
  };

  return (
    <div style={{ marginTop: '2rem' }}>
      <h2>🖥️ Screen Capture</h2>
      <button onClick={startCapture}>Start Screen Capture</button>
      <div>
        <video ref={videoRef} style={{ marginTop: '10px', maxWidth: '600px', border: '1px solid #ccc' }} autoPlay />
      </div>
    </div>
  );
};

export default ScreenCapture;
EOF

# 5. Update components/ModelResponse.tsx for dummy UI
cat > $FRONTEND_DIR/src/components/ModelResponse.tsx << 'EOF'
'use client';

const ModelResponse = () => {
  return (
    <div style={{ marginTop: '2rem' }}>
      <h2>📦 Multimodal Response Area</h2>
      <p>Responses from your multimodal model will be shown here.</p>
    </div>
  );
};

export default ModelResponse;
EOF

# 6. Ensure apiClient.ts is correct:
cat > $FRONTEND_DIR/src/utils/apiClient.ts << 'EOF'
import axios from 'axios';

const apiClient = axios.create({
  baseURL: 'http://localhost:8000/api',
});

export default apiClient;
EOF

# 7. Ensure mediaUtils.ts is correct:
cat > $FRONTEND_DIR/src/utils/mediaUtils.ts << 'EOF'
export const captureScreen = async (): Promise<MediaStream | null> => {
  try {
    return await navigator.mediaDevices.getDisplayMedia({ video: true });
  } catch (error) {
    console.error(error);
    return null;
  }
};

export const captureMicrophone = async (): Promise<MediaStream | null> => {
  try {
    return await navigator.mediaDevices.getUserMedia({ audio: true });
  } catch (error) {
    console.error(error);
    return null;
  }
};
EOF

echo "✅ Frontend setup completed successfully!"