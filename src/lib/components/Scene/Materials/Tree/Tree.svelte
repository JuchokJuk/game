<script lang="ts">
	import { T, useFrame, useLoader } from "@threlte/core";

	import { SRGBColorSpace, TextureLoader } from "three";

	import fragmentShader from "./simpleShaders/fragmentShader.glsl?raw";
	import vertexShader from "./simpleShaders/vertexShader.glsl?raw";
	import { volume } from "$lib/stores/volume";
	import { musicStarted } from "$lib/stores/musicStarted";
	import { quadOut } from "svelte/easing";
	import { tweened } from "svelte/motion";

	let time = 0;

	const tweenedGlitchiness = tweened(0, {
		duration: 3200,
		easing: quadOut
	});

	$: if ($musicStarted) {
		time = 0;
		$tweenedGlitchiness = 1;
	} else {
		$tweenedGlitchiness = 0;
	}

	let uniforms: { [key: string]: any };

	const texture = useLoader(TextureLoader).load("models/Terrain denoised/Trees baked.png");
	const glitchedTexture = useLoader(TextureLoader).load("models/Terrain glitched/Trees baked.png");

	const textures = Promise.all([texture, glitchedTexture]);

	textures.then(([texture, glitchedTexture]) => {
		texture.flipY = false;
		texture.colorSpace = SRGBColorSpace;

		glitchedTexture.flipY = false;
		glitchedTexture.colorSpace = SRGBColorSpace;
		
		uniforms = {
			time: { value: time },
			initialTexture: { value: texture },
			glitchedTexture: {value: glitchedTexture},
			glitchiness: { value: $tweenedGlitchiness }
		};
	});

	useFrame((_, delta) => {
		time += delta;
	});
</script>

{#if uniforms}
	<T.ShaderMaterial
		{vertexShader}
		{fragmentShader}
		{uniforms}
		uniforms.time.value={time + $volume * 2}
		uniforms.glitchiness.value={$tweenedGlitchiness}
	/>
{/if}
