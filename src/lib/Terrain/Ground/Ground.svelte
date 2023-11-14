<script lang="ts">
	import { T, useFrame } from '@threlte/core';
	import { AutoColliders, Collider, useRapier } from '@threlte/rapier';
	import { PlaneGeometry, ShaderLib, UniformsUtils } from 'three';
	import { DEG2RAD } from 'three/src/math/MathUtils';

	import { terrain, terrainWithWall } from '../terrain';

	const geometry = new PlaneGeometry(400, 400, 64, 64);
	const vertices = geometry.getAttribute('position').array;

	for (let i = 0; i < vertices.length; i += 3) {
		const x = vertices[i];
		const y = vertices[i + 1];
		vertices[i + 2] = terrain(x, y);
	}

	const wallGeometry = new PlaneGeometry(400, 400, 64, 64);
	const wallVertices = wallGeometry.getAttribute('position').array;

	for (let i = 0; i < wallVertices.length; i += 3) {
		const x = wallVertices[i];
		const y = wallVertices[i + 1];
		wallVertices[i + 2] = terrainWithWall(x, y);
	}
	wallGeometry.rotateX(-90 * DEG2RAD);
	const coliderVertices = wallGeometry.getAttribute('position').array as Float32Array;
	const coliderIndixes = wallGeometry.index?.array as Uint32Array;

	// ---- //

	import fragmentShader from './defaultShaders/fragmentShader.glsl?raw';
	import vertexShader from './defaultShaders/vertexShader.glsl?raw';
	import { onMount } from 'svelte';

	// let time = 0;

	let uniforms = UniformsUtils.merge([
		ShaderLib.standard.uniforms,
		{
			roughness: { value: 1 },
			metalness: { value: 0 }
			// time: { value: time }
		}
	]);

	// useFrame(({ clock }) => {
	// 	time = clock.getElapsedTime();
	// });

	const { rapier, world } = useRapier();

	onMount(() => {
		const trimesh = new rapier.TriMesh(coliderVertices, coliderIndixes);
		const colliderDesc = new rapier.ColliderDesc(trimesh);
		colliderDesc
			.setTranslation(0.0, 0.0, 0.0)
			.setRotation({ w: 1, x: 0, y: 0.0, z: 0.0 })
			.setDensity(1.0)
			.setFriction(0.5)
			.setSensor(false);
		world.createCollider(colliderDesc);
	});
</script>

<!-- <AutoColliders shape="trimesh"> -->
	<T.Mesh {geometry} rotation={[-90 * DEG2RAD, 0, 0]} receiveShadow>
		<T.MeshStandardMaterial color={[0.0, 0.8, 0.2]} metalness={0} roughness={1} />
		<!-- uniforms.time.value={time} -->
		<!-- <T.ShaderMaterial {vertexShader} {fragmentShader} {uniforms} fog lights /> -->
	</T.Mesh>
<!-- </AutoColliders> -->

<!-- <AutoColliders shape="trimesh">
	<T.Mesh geometry={wallGeometry} rotation={[-90 * DEG2RAD, 0, 0]}>
		<T.MeshBasicMaterial transparent opacity={0} />
	</T.Mesh>
</AutoColliders> -->
