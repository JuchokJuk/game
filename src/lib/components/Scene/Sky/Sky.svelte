<script lang="ts">
	import { T, useFrame } from "@threlte/core";

	import fragmentShader from "./simpleShaders/fragmentShader.glsl?raw";
	import vertexShader from "./simpleShaders/vertexShader.glsl?raw";
	import { volume } from "$lib/stores/volume";

	let time = 0;

	let uniforms = {
		time: { value: time }
	};

	useFrame(({ clock }) => {
		time = clock.getElapsedTime();
	});
</script>

<T.Mesh rotation={[time * 0.01, time * 0.01, time * 0.01]}>
	<T.SphereGeometry args={[-20 * 10, 32]} />
	<T.ShaderMaterial
		{vertexShader}
		{fragmentShader}
		{uniforms}
		uniforms.time.value={time + $volume * 2}
	/>
</T.Mesh>
