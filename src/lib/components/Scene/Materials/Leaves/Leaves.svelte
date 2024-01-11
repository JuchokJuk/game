<script lang="ts">
	import { T, useLoader } from "@threlte/core";

	import { SRGBColorSpace, TextureLoader } from "three";

	import fragmentShader from "./simpleShaders/fragmentShader.glsl?raw";
	import vertexShader from "./simpleShaders/vertexShader.glsl?raw";
	import { musicStarted } from "$lib/stores/musicStarted";
	import { quadOut } from "svelte/easing";
	import { tweened } from "svelte/motion";

	const tweenedGlitchiness = tweened(0, {
		duration: 3200,
		easing: quadOut
	});

	$: if ($musicStarted) {
		$tweenedGlitchiness = 1;
	} else {
		$tweenedGlitchiness = 0;
	}

	let uniforms: { [key: string]: any };

	const texture = useLoader(TextureLoader).load("models/Terrain denoised/Leaves baked.png");

	texture.then((texture) => {
		texture.flipY = false;
		texture.colorSpace = SRGBColorSpace;
		uniforms = {
			initialTexture: { value: texture },
			glitchiness: { value: $tweenedGlitchiness }
		};
	});
</script>

{#if uniforms}
	<T.ShaderMaterial
		{vertexShader}
		{fragmentShader}
		{uniforms}
		uniforms.glitchiness.value={$tweenedGlitchiness}
		transparent
	/>
{/if}
