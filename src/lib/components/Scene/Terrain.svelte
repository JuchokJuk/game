<script lang="ts">
	import { AutoColliders } from "@threlte/rapier";
	import { T, useLoader } from "@threlte/core";
	import { useGltf } from "@threlte/extras";
	import GrassBlade from "./Materials/GrassBlade/GrassBlade.svelte";
	import { BufferAttribute, FileLoader } from "three";

	const gltf = useGltf("models/Terrain denoised/Terrain baked.gltf");

	// const UV = useLoader(FileLoader).load("models/grassSimpleUV.bin");

	const grassSimple = useGltf("models/GrassSimple.glb");

	Promise.all([grassSimple, gltf]).then(([grassSimple, gltf]) => {
		gltf.nodes.Grass.geometry.setAttribute("simpleUV", grassSimple.nodes.Ground006.geometry.attributes.uv);
	});
</script>

{#await gltf then gltf}
	<AutoColliders shape="trimesh">
		<T.Mesh
			geometry={gltf.nodes.Magic_stone.geometry}
			material={gltf.materials["Magic stone"]}
			position={[0, 7, 0]}
		/>
		<T.Mesh geometry={gltf.nodes.Trees.geometry} material={gltf.materials.Tree} />
		<T.Mesh geometry={gltf.nodes.Bushes.geometry} material={gltf.materials.Grass} />
		<T.Mesh geometry={gltf.nodes.Stones.geometry} material={gltf.materials.Stone} />
		<T.Mesh geometry={gltf.nodes.Grass_ground.geometry} material={gltf.materials["Grass ground"]} />
		<T.Mesh geometry={gltf.nodes.Dirt_ground.geometry} material={gltf.materials.Dirt} />
		<T.Mesh geometry={gltf.nodes.Leaves.geometry} material={gltf.materials.Leaves} />
	</AutoColliders>

	<T.Mesh geometry={gltf.nodes.Grass.geometry}>
		<!-- <T is={gltf.materials["Grass blade"]} /> -->
		<GrassBlade />
	</T.Mesh>
{/await}

<!-- 

<script>
	import { Group } from 'three'
	import { T, forwardEventHandlers } from '@threlte/core'
	import { useGltf } from '@threlte/extras'
  
	export const ref = new Group()
  
	const gltf = useGltf('/staticmodelsTerrain.glb')
  
	const component = forwardEventHandlers()
  </script>
  
  <T is={ref} dispose={false} {...$$restProps} bind:this={$component}>
	{#await gltf}
	  <slot name="fallback" />
	{:then gltf}
	  <T.Mesh geometry={gltf.nodes.Magic_stone.geometry} material={gltf.materials['Magic stone']} position={[0, 7, 0]} />
	  <T.Mesh geometry={gltf.nodes.Trees.geometry} material={gltf.materials.Tree} />
	  <T.Mesh geometry={gltf.nodes.Leaves.geometry} material={gltf.materials.Leaves} />
	  <T.Mesh geometry={gltf.nodes.Bushes.geometry} material={gltf.materials.Grass} />
	  <T.Mesh geometry={gltf.nodes.Stones.geometry} material={gltf.materials.Stone} />
	  <T.Mesh geometry={gltf.nodes.Grass_ground.geometry} material={gltf.materials['Grass ground']} />
	  <T.Mesh geometry={gltf.nodes.Dirt_ground.geometry} material={gltf.materials.Dirt} />
	  <T.Mesh geometry={gltf.nodes.Grass.geometry} material={gltf.materials['Grass blade']} />
	{:catch error}
	  <slot name="error" {error} />
	{/await}
  
	<slot {ref} />
  </T>
  

 -->
