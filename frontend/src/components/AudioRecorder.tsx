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
