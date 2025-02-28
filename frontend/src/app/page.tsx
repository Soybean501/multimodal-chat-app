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
