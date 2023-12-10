<script lang="ts">
	import { AutoColliders } from "@threlte/rapier";
	import { T } from "@threlte/core";
	import { useGltf } from "@threlte/extras";
	import GrassBlade from "./Materials/GrassBlade/GrassBlade.svelte";
	import Tree from "./Materials/Tree/Tree.svelte";

	const gltf = useGltf("models/Terrain.glb");
</script>

{#await gltf then gltf}
	<AutoColliders shape="trimesh">
		<T.Mesh geometry={gltf.nodes.Ground_mesh.geometry} material={gltf.materials.Stone} />
		<T.Mesh geometry={gltf.nodes.Ground_mesh_1.geometry} material={gltf.materials.Stone} />
		<T.Mesh
			geometry={gltf.nodes.Magic_stone.geometry}
			material={gltf.materials.Stone}
			position={[0, 7, 0]}
		/>

		<!-- <T.Mesh geometry={gltf.nodes.Ground_mesh_3.geometry} material={gltf.materials.Tree} /> -->
		<T.Mesh geometry={gltf.nodes.Ground_mesh_3.geometry}>
			<Tree />
		</T.Mesh>
	</AutoColliders>

	<!-- <T.Mesh geometry={gltf.nodes.Ground_mesh_2.geometry} material={gltf.materials["Grass blade"]} /> -->
	<T.Mesh geometry={gltf.nodes.Ground_mesh_2.geometry}>
		<GrassBlade />
	</T.Mesh>

	<!-- <T.Mesh geometry={gltf.nodes.Ground_mesh_4.geometry} material={gltf.materials.Leaves} /> -->
{/await}
