<script lang="ts">
	import { T, useFrame } from '@threlte/core';
	import { InstancedMesh, Instance } from '@threlte/extras';
	import { DEG2RAD, seededRandom } from 'three/src/math/MathUtils';
	import { noise, terrain } from '../terrain';
	import { DoubleSide, PlaneGeometry, UniformsLib, UniformsUtils } from 'three';

	import fragmentShader from './simpleShaders/fragmentShader.glsl?raw';
	import vertexShader from './simpleShaders/vertexShader.glsl?raw';
	// import { playerPosition } from '$lib/Player/playerPositionStore';

	let grass: { position: [number, number, number]; height: number; rotation: number }[] = [];

	// function round(value: number, howStrong: number) {
	// 	return Math.round(value / howStrong) * howStrong;
	// }

	// const R = 80; // 20
	// const instancesCount = R * R; //40000 / 2;
	// const density = 0.5;
	// $: {
	// 	grass = [];
	// 	for (let y = 0; y < R; y++) {
	// 		for (let x = 0; x < R; x++) {
	// 			let bladeX = round((x - R * 0.5) * density + $playerPosition.x, density);
	// 			let bladeY = round((y - R * 0.5) * density - $playerPosition.z, density);
	// 			const random = seededRandom(bladeX + bladeY);
	// 			bladeX += Math.sin(random);
	// 			bladeY += Math.cos(random);
	// 			const noiseValue = noise(bladeX * 0.05, bladeY * 0.05) * 0.5 + 0.5;
	// 			grass.push({
	// 				position: [bladeX, bladeY, terrain(bladeX, bladeY)],
	// 				height: (random + noiseValue) / 4 + 0.1,
	// 				rotation: random * 360
	// 			});
	// 		}
	// 	}
	// 	grass = grass;
	// }

	const R = 20
	const instancesCount = 40000;

	for (let i = 0; i < instancesCount; i++) {
		const r = R * Math.sqrt(Math.random());
		const theta = Math.random() * 2 * Math.PI;
		const x = r * Math.cos(theta);
		const y = r * Math.sin(theta);

		const noiseValue = noise(x * 0.05, y * 0.05) * 0.5 + 0.5;
		if (Math.random() ** ((R - r) / R) > noiseValue) continue;

		const height = (Math.random() + noiseValue) / 4 + 0.1;
		const rotation = Math.random() * 360;

		grass.push({ position: [x, y, terrain(x, y)], height, rotation });
	}

	let time = 0;

	const uniforms = UniformsUtils.merge([UniformsLib.fog, { time: { value: time } }]);

	useFrame(({ clock }) => {
		time = clock.getElapsedTime();
	});

	const geometry = new PlaneGeometry(0.1, 1, 1, 1);
	geometry.translate(0, 0.5, 0);
</script>

<T.Group rotation={[-90 * DEG2RAD, 0, 0]}>
	<InstancedMesh limit={instancesCount} range={instancesCount} {geometry} frustumCulled={false}>
		<T.ShaderMaterial
			side={DoubleSide}
			{vertexShader}
			{fragmentShader}
			{uniforms}
			uniforms.time.value={time}
			fog
		/>

		{#each grass as blade}
			<Instance
				position={blade.position}
				rotation={[90 * DEG2RAD, blade.rotation * DEG2RAD, 0]}
				scale={[1, blade.height, 1]}
			/>
		{/each}
	</InstancedMesh>
</T.Group>
