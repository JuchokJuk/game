<script lang="ts">
	import { actor, type Point } from '$lib/Actor/ActorStore';
	import { T } from '@threlte/core';

	import fragmentShader from './simpleShaders/fragmentShader.glsl?raw';
	import vertexShader from './simpleShaders/vertexShader.glsl?raw';
	import { Instance, InstancedMesh } from '@threlte/extras';

	// import { lerp } from 'three/src/math/MathUtils';

	// let prevPoints: Point[] = [];
	// let points: Point[] = [];

	// $: {
	// 	if (prevPoints.length === 0) {
	// 		prevPoints = $actor;
	// 		points = $actor;
	// 	} else {
	// 		prevPoints = points;

	// 		for (let i = 0; i < $actor.length; i++) {
	// 			points[i] = {
	// 				x: lerp(prevPoints[i].x, $actor[i].x, 0.1),
	// 				y: lerp(prevPoints[i].y, $actor[i].y, 0.1),
	// 				z: lerp(prevPoints[i].z, $actor[i].z, 0.1)
	// 			};
	// 		}
	// 		points = points;
	// 	}
	// }
</script>

<InstancedMesh frustumCulled={false}>
	<T.SphereGeometry args={[0.1, 4, 4]} />
	<T.ShaderMaterial {vertexShader} {fragmentShader} />

	{#each $actor as point}
		<Instance position={[point.x * 0.125 - 50, -point.y * 0.125 + 100, point.z * 0.125 + 50]} />
	{/each}
</InstancedMesh>
