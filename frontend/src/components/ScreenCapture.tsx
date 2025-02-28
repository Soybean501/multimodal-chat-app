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
