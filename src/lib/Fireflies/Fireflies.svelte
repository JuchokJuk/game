<script lang="ts">
	import { T, useFrame } from '@threlte/core';
	import { InstancedMesh, Instance } from '@threlte/extras';
	import { createNoise2D, type NoiseFunction2D } from 'simplex-noise';

	import fragmentShader from './simpleShaders/fragmentShader.glsl?raw';
	import vertexShader from './simpleShaders/vertexShader.glsl?raw';

	const R1 = 20;
	const R2 = 80;
	const instancesCount = 16*2*2;

	let lights: {
		noise: NoiseFunction2D;
		startPosition: [number, number, number];
		position: [number, number, number];
	}[] = [];

	for (let i = 0; i < instancesCount; i++) {
		const r = (i < 16 ? R1 : R2) * Math.sqrt(Math.random());
		const theta = Math.random() * 2 * Math.PI;
		const x = r * Math.cos(theta);
		const y = r * Math.sin(theta);

		lights.push({
			noise: createNoise2D(),
			startPosition: [x, (Math.random() + 1) * 16, y],
			position: [0, 0, 0]
		});
	}

	let time = 0;

	useFrame(({ clock }) => {
		time = clock.getElapsedTime();
		for (let i = 0; i < lights.length; i++) {
			lights[i].position = [
				lights[i].startPosition[0] + lights[i].noise(0, time * 0.1) * 2,
				lights[i].startPosition[1] + lights[i].noise(16, time * 0.1) * 2,
				lights[i].startPosition[2] + lights[i].noise(32, time * 0.1) * 2
			];
		}
		lights = lights;
	});
</script>

<!-- updating positions on instanced mesh causes frustum culling issues -->
<InstancedMesh limit={instancesCount} range={instancesCount} frustumCulled={false}>
	<T.SphereGeometry args={[0.1, 4, 4]} />
	<T.ShaderMaterial {vertexShader} {fragmentShader} />

	{#each lights as light}
		<Instance position={light.position} />
	{/each}
</InstancedMesh>
