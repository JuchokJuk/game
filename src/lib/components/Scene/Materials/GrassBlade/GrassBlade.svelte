<script lang="ts">
	import { T, useFrame } from "@threlte/core";
	import { DoubleSide, UniformsLib, UniformsUtils } from "three";

	import fragmentShader from "./glitchShaders/fragmentShader.glsl?raw";
	import vertexShader from "./glitchShaders/vertexShader.glsl?raw";
	import { volume } from "$lib/stores/volume";

	let time = 0;

	const uniforms = UniformsUtils.merge([UniformsLib.fog, { time: { value: time } }]);

	useFrame(({ clock }) => {
		time = clock.getElapsedTime();
	});
</script>

<T.ShaderMaterial
	side={DoubleSide}
	{vertexShader}
	{fragmentShader}
	{uniforms}
	uniforms.time.value={time + $volume * 2}
	fog
/>
