<script lang="ts">
	import { T, useFrame } from "@threlte/core";

	import fragmentShader from "./simpleShaders/fragmentShader.glsl?raw";
	import vertexShader from "./simpleShaders/vertexShader.glsl?raw";
	import { volume } from "$lib/stores/volume";
	import { quadOut } from "svelte/easing";
	import { musicStarted } from "$lib/stores/musicStarted";
	import { tweened } from "svelte/motion";
	import { swordRotation } from "$lib/stores/swordRotation";

	let time = 0;

	const tweenedGlitchiness = tweened(0, {
		duration: 800,
		easing: quadOut
	});

	$: if ($musicStarted) {
		time = 0;
		$tweenedGlitchiness = 1;
	} else {
		$tweenedGlitchiness = 0;
	}

	const uniforms = {
		time: { value: time },
		glitchiness: { value: $tweenedGlitchiness }
	};

	useFrame((_, delta) => {
		time += delta;
	});
</script>

<T.Mesh rotation={[$swordRotation, $swordRotation, $swordRotation]}>
	<T.SphereGeometry args={[-64 * 10, 32]} />
	<T.ShaderMaterial
		{vertexShader}
		{fragmentShader}
		{uniforms}
		uniforms.time.value={time + $volume * 8}
		uniforms.glitchiness.value={$tweenedGlitchiness}
	/>
</T.Mesh>
