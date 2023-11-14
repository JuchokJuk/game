import '@mediapipe/face_mesh';
import '@tensorflow/tfjs-core';
// Register WebGL backend.
import '@tensorflow/tfjs-backend-webgl';
import * as faceLandmarksDetection from '@tensorflow-models/face-landmarks-detection';

const model = faceLandmarksDetection.SupportedModels.MediaPipeFaceMesh;
const detectorConfig = {
	runtime: 'tfjs',
	solutionPath: 'https://cdn.jsdelivr.net/npm/@mediapipe/face_mesh',
	refineLandmarks: false
	// or 'base/node_modules/@mediapipe/face_mesh' in npm.
};
const detector = await faceLandmarksDetection.createDetector(model, detectorConfig);

postMessage({
	action: 'start'
});

const estimationConfig = { flipHorizontal: false };

onmessage = async (event) => {
	const buffer = event.data;
	const array = new Uint8ClampedArray(buffer);
	const imData = new ImageData(array, 640, 480);

	const faces = await detector.estimateFaces(imData, estimationConfig);
	postMessage({
		action: 'takeFaces',
		payload: faces
	});
};
