<script lang="ts">
	import { AutoColliders } from "@threlte/rapier";
	import { T } from "@threlte/core";
	import { useGltf } from "@threlte/extras";
	import GrassBlade from "./Materials/GrassBlade/GrassBlade.svelte";

	const wall = useGltf("models/Wall.glb");

	const terrain = useGltf("models/Terrain denoised/Terrain baked.gltf");

	// const UV = useLoader(FileLoader).load("models/grassSimpleUV.bin");

	const grassSimple = useGltf("models/GrassSimple.glb");

	const models = Promise.all([terrain, grassSimple, wall]);

	models.then(([terrain, grassSimple]) => {
		terrain.nodes.Grass.geometry.setAttribute(
			"simpleUV",
			grassSimple.nodes.Ground006.geometry.attributes.uv
		);
	});
</script>

{#await models then [terrain, _grassSimple, wall]}
	<AutoColliders shape="trimesh" friction={0}>
		<T.Mesh
			geometry={terrain.nodes.Magic_stone.geometry}
			material={terrain.materials["Magic stone"]}
			position={[0, 7, 0]}
		/>
		<T.Mesh geometry={terrain.nodes.Trees.geometry} material={terrain.materials.Tree} />
		<T.Mesh geometry={terrain.nodes.Bushes.geometry} material={terrain.materials.Grass} />
		<T.Mesh geometry={terrain.nodes.Stones.geometry} material={terrain.materials.Stone} />

		<T.Mesh
			geometry={terrain.nodes.Grass_ground.geometry}
			material={terrain.materials["Grass ground"]}
		/>
		<T.Mesh geometry={terrain.nodes.Dirt_ground.geometry} material={terrain.materials.Dirt} />
		<T.Mesh geometry={terrain.nodes.Leaves.geometry} material={terrain.materials.Leaves} />
	</AutoColliders>

	<T.Mesh geometry={terrain.nodes.Grass.geometry}>
		<!-- <T is={gltf.materials["Grass blade"]} /> -->
		<GrassBlade />
	</T.Mesh>

	<AutoColliders shape="trimesh" friction={0}>
		<T.Mesh geometry={wall.nodes.Cylinder.geometry} />
	</AutoColliders>
{/await}
