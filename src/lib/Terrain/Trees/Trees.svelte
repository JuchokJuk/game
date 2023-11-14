<script lang="ts">
	import { T, useFrame } from '@threlte/core';
	import { InstancedMesh, Instance } from '@threlte/extras';
	import { DEG2RAD } from 'three/src/math/MathUtils';
	import { terrain } from '../terrain';

	import { useLoader } from '@threlte/core';
	import { STLLoader } from 'three/examples/jsm/loaders/STLLoader';
	import { generateTreesPositions, type Tree } from './generateTreesPositions';
	import { onMount } from 'svelte';
	import { AutoColliders, Collider } from '@threlte/rapier';
	import {
		ShaderLib,
		UniformsUtils,
		type BufferGeometry,
		type NormalBufferAttributes
	} from 'three';
	import { mergeVertices } from 'three/examples/jsm/utils/BufferGeometryUtils';

	import fragmentShader from './defaultShaders/fragmentShader.glsl?raw';
	import vertexShader from './defaultShaders/vertexShader.glsl?raw';

	const treesGeometriesPromises = [
		useLoader(STLLoader).load('./dead_tree_1.stl'),
		useLoader(STLLoader).load('./dead_tree_2.stl'),
		useLoader(STLLoader).load('./dead_tree_3.stl'),
		useLoader(STLLoader).load('./dead_tree_4.stl'),
		useLoader(STLLoader).load('./dead_tree_5.stl')
	];

	let treesGeometries: BufferGeometry<NormalBufferAttributes>[];

	let treesGroups: { geometry: BufferGeometry<NormalBufferAttributes>; positions: Tree[] }[] = [];

	onMount(async () => {
		treesGeometries = await Promise.all(treesGeometriesPromises);
		for (const geometry of treesGeometries) {
			treesGroups.push({
				geometry, // geometry: mergeVertices(geometry),
				positions: generateTreesPositions(terrain)
			});
		}
		treesGroups = treesGroups;
	});

	// ---- //

	let time = 0;

	let uniforms = UniformsUtils.merge([
		ShaderLib.standard.uniforms,
		{
			roughness: { value: 1 },
			metalness: { value: 0 },
			time: { value: time }
		}
	]);

	useFrame(({ clock }) => {
		time = clock.getElapsedTime();
	});
</script>

{#each treesGroups as group}
	<T.Group rotation={[-90 * DEG2RAD, 0, 0]}>
		<InstancedMesh geometry={group.geometry} castShadow>
			<T.MeshStandardMaterial color={[0.1, 0.1, 0.1]} roughness={1} metalness={0} flatShading />
			<!-- <T.ShaderMaterial {vertexShader} {fragmentShader} {uniforms} uniforms.time.value={time} fog lights/> -->

			{#each group.positions as tree}
				<T.Group
					position={[tree.position[0], tree.position[1], tree.position[2] + 2]}
					rotation={[-90 * DEG2RAD, 0, 0]}
				>
					<Collider shape={'cylinder'} args={[2, 0.4 * tree.scale]}/>
				</T.Group>
				<Instance {...tree} />
			{/each}
		</InstancedMesh>
	</T.Group>
{/each}

<!-- <T.Group rotation={[-90 * DEG2RAD, 0, 0]}>
	{#each treesGroups as group}
		{#each group.positions as tree}
			<AutoColliders shape="trimesh">
				<T.Mesh geometry={group.geometry} {...tree}>
					<T.MeshStandardMaterial color={[0.1, 0.1, 0.1]} roughness={1} metalness={0} flatShading />
				</T.Mesh>
			</AutoColliders>
		{/each}
	{/each}
</T.Group> -->
