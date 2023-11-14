<script lang="ts">
	import { T } from '@threlte/core';
	import { InstancedMesh, Instance } from '@threlte/extras';
	import { DEG2RAD } from 'three/src/math/MathUtils';
	import { noise, terrain } from './terrain';

	const stones: {
		position: [number, number, number];
		rotation: [number, number, number];
		scale: number;
	}[] = [];

	const R = 128;
	for (let i = 0; i < 2048; i++) {
		const r = R * Math.sqrt(Math.random());
		const theta = Math.random() * 2 * Math.PI;
		const x = r * Math.cos(theta);
		const y = r * Math.sin(theta);

		if (noise(x * 0.05, y * 0.05) > 0) continue;

		stones.push({
			position: [x, y, terrain(x, y)],
			rotation: [
				Math.random() * 360 * DEG2RAD,
				Math.random() * 360 * DEG2RAD,
				Math.random() * 360 * DEG2RAD
			],
			scale: Math.random() + 0.5
		});
	}
</script>

<T.Group rotation={[-90 * DEG2RAD, 0, 0]}>
	<InstancedMesh>
		<T.SphereGeometry args={[0.2, 4, 4]} />
		<T.MeshStandardMaterial color={[0.2, 0.6, 0.4]} roughness={1} metalness={0} flatShading />

		{#each stones as stone}
			<Instance {...stone} />
		{/each}
	</InstancedMesh>
</T.Group>
