import { DEG2RAD } from 'three/src/math/MathUtils';

export interface Tree {
	position: [number, number, number];
	rotation: [number, number, number];
	scale: number;
}

export function generateTreesPositions(
	terrain: (x: number, y: number) => number,
) {
	const trees: Tree[] = [];

	const instancesCount = 50;
	const R = 80;

	for (let i = 0; i < instancesCount; i++) {
		const r = R * Math.sqrt(Math.random());
		const theta = Math.random() * 2 * Math.PI;
		const x = r * Math.cos(theta);
		const y = r * Math.sin(theta);

		trees.push({
			position: [x, y, terrain(x, y)],
			rotation: [0, 0, Math.random() * 360 * DEG2RAD],
			scale: Math.random()*1.5 + 1
		});
	}

	return trees;
}
