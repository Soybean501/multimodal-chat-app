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
