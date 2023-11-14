import { clamp } from '$lib/clamp';
import { createNoise2D } from 'simplex-noise';

function smoothstep(edge0: number, edge1: number, x: number) {
	const t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
	return t * t * (3.0 - 2.0 * t);
}

export const noise = createNoise2D();

function terrainSideView(x: number) {
	return smoothstep(128, 75, x) * 10 + smoothstep(50, 0, x) * 5 - 8;
}

function wallSideView(x: number) {
	return (
		smoothstep(128, 75, x) * 10 + smoothstep(50, 0, x) * 5 - 8 + smoothstep(0, 1, x - 92) * 128
	);
}

export function terrainWithWall(x: number, y: number) {
	return wallSideView(Math.sqrt(x ** 2 + y ** 2)) + noise(x * 0.05, y * 0.05) * 0.5;
}

export function terrain(x: number, y: number) {
	return terrainSideView(Math.sqrt(x ** 2 + y ** 2)) + noise(x * 0.05, y * 0.05) * 0.5;
}
