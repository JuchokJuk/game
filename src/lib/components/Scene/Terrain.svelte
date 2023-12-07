<script lang="ts">
	import { AutoColliders } from "@threlte/rapier";
	import { Group } from "three";
	import { T } from "@threlte/core";
	import { useGltf } from "@threlte/extras";
	import GrassBlade from "./Materials/GrassBlade/GrassBlade.svelte";
	import Tree from "./Materials/Tree/Tree.svelte";
	import Player from "./Player.svelte";

	export const ref = new Group();

	const gltf = useGltf("/Terrain.glb");
</script>

{#await gltf then gltf}
	<AutoColliders shape="trimesh">
		<T.Mesh
			geometry={gltf.nodes.Magic_stone.geometry}
			material={gltf.materials.Stone}
			position={[0, 7, 0]}
			receiveShadow
			castShadow
		/>
		<T.Mesh geometry={gltf.nodes.Ground_mesh.geometry} material={gltf.materials.Stone} />
		<T.Mesh
			geometry={gltf.nodes.Ground_mesh_1.geometry}
			material={gltf.materials.Stone}
			receiveShadow
			castShadow
		/>
		<T.Mesh geometry={gltf.nodes.Ground_mesh_3.geometry} receiveShadow castShadow>
			<!-- material={gltf.materials.Tree} -->
			<Tree />
		</T.Mesh>
	</AutoColliders>
	<T.Mesh geometry={gltf.nodes.Ground_mesh_2.geometry} receiveShadow>
		<GrassBlade />
	</T.Mesh>
	<Player position={[0, 0, 28]} />
{/await}
