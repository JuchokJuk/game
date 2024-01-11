<script lang="ts">
	import { onDestroy } from "svelte";
	import { AutoColliders, useRapier } from "@threlte/rapier";
	import type { Collider } from "@dimforge/rapier3d-compat";
	import { T } from "@threlte/core";
	import { useGltf } from "@threlte/extras";
	import GrassBlade from "./Materials/GrassBlade/GrassBlade.svelte";
	import Tree from "./Materials/Tree/Tree.svelte";
	import Dirt from "$lib/components/Scene/Materials/Dirt/Dirt.svelte";
	import GrassGround from "$lib/components/Scene/Materials/GrassGround/GrassGround.svelte";
	import Stone from "./Materials/Stone/Stone.svelte";
	import Leaves from "./Materials/Leaves/Leaves.svelte";
	import Bushes from "./Materials/Bushes/Bushes.svelte";
	import MagicStone from "./Materials/Magic stone/MagicStone.svelte";

	const { rapier, world } = useRapier();

	const wall = useGltf("models/Wall.glb");

	const terrain = useGltf("models/Terrain denoised/Terrain baked.gltf");

	// const UV = useLoader(FileLoader).load("models/grassSimpleUV.bin");

	const grassSimple = useGltf("models/GrassSimple.glb");

	const models = Promise.all([terrain, grassSimple, wall]);

	let collider: Collider;

	models.then(([terrain, grassSimple, wall]) => {
		const wallGeometry = wall.nodes.Cylinder.geometry;

		const coliderVertices = wallGeometry.getAttribute("position").array as Float32Array;
		const coliderIndixes = wallGeometry.index?.array as Uint32Array;

		const trimesh = new rapier.TriMesh(coliderVertices, coliderIndixes);
		const colliderDesc = new rapier.ColliderDesc(trimesh);
		colliderDesc
			.setTranslation(0.0, 0.0, 0.0)
			.setRotation({ w: 1, x: 0, y: 0.0, z: 0.0 })
			.setDensity(1.0)
			.setFriction(0.0)
			.setSensor(false);

		collider = world.createCollider(colliderDesc);

		terrain.nodes.Grass.geometry.setAttribute(
			"simpleUV",
			grassSimple.nodes.Ground006.geometry.attributes.uv
		);
	});

	onDestroy(() => {
		if (collider) world.removeCollider(collider, false);
	});
</script>

{#await models then [terrain]}
	<AutoColliders shape="trimesh" friction={0}>
		<T.Mesh geometry={terrain.nodes.Magic_stone.geometry} position={[0, 7, 0]}>
			<MagicStone />
		</T.Mesh>
		<T.Mesh geometry={terrain.nodes.Trees.geometry}>
			<Tree />
		</T.Mesh>
		<T.Mesh geometry={terrain.nodes.Bushes.geometry}>
			<Bushes />
		</T.Mesh>
		<T.Mesh geometry={terrain.nodes.Stones.geometry}>
			<Stone />
		</T.Mesh>

		<T.Mesh geometry={terrain.nodes.Grass_ground.geometry}>
			<GrassGround />
		</T.Mesh>
		<T.Mesh geometry={terrain.nodes.Dirt_ground.geometry}>
			<Dirt />
		</T.Mesh>
	</AutoColliders>

	<T.Mesh geometry={terrain.nodes.Leaves.geometry}>
		<Leaves />
	</T.Mesh>

	<T.Mesh geometry={terrain.nodes.Grass.geometry}>
		<GrassBlade />
	</T.Mesh>
{/await}
