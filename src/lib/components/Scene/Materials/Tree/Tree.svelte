<script lang="ts">
	import { T, useFrame } from "@threlte/core";

	import { ShaderLib, UniformsUtils } from "three";

	import fragmentShader from "./defaultShaders/fragmentShader.glsl?raw";
	import vertexShader from "./defaultShaders/vertexShader.glsl?raw";
	import { volume } from "$lib/stores/volume";

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

<T.ShaderMaterial
	{vertexShader}
	{fragmentShader}
	{uniforms}
	uniforms.time.value={time + $volume * 2}
	fog
	lights
/>
