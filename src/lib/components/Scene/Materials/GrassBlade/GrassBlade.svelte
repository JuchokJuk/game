<script lang="ts">
	import { T, useFrame, useLoader } from "@threlte/core";
	import { DoubleSide, SRGBColorSpace, TextureLoader } from "three";

	import fragmentShader from "./simpleShaders/fragmentShader.glsl?raw";
	import vertexShader from "./simpleShaders/vertexShader.glsl?raw";
	import { volume } from "$lib/stores/volume";
	import { tweened } from "svelte/motion";
	import { quadOut } from "svelte/easing";
	import { musicStarted } from "$lib/stores/musicStarted";

	let time = 0;
	let windAnimationTime = 0;

	const tweenedGlitchiness = tweened(0, {
		duration: 6400,
		easing: quadOut
	});

	$: if ($musicStarted) {
		time = 0;
		$tweenedGlitchiness = 1;
	} else {
		$tweenedGlitchiness = 0;
	}

	let uniforms: { [key: string]: any };

	const texture = useLoader(TextureLoader).load("models/Terrain denoised/Grass baked.png");
	const glitchedTexture = useLoader(TextureLoader).load("models/Terrain glitched/Grass baked.png");

	const textures = Promise.all([texture, glitchedTexture]);

	textures.then(([texture, glitchedTexture]) => {
		texture.flipY = false;
		texture.colorSpace = SRGBColorSpace;
		
		glitchedTexture.flipY = false;
		glitchedTexture.colorSpace = SRGBColorSpace;
		
		uniforms = {
			time: { value: time },
			windAnimationTime: { value: windAnimationTime },
			glitchiness: { value: $tweenedGlitchiness },
			sound: { value: $volume * 2 },
			grassTexture: { value: texture },
			glitchedTexture: {value: glitchedTexture},
		};
	});

	useFrame(({ clock }, delta) => {
		time += delta;
		windAnimationTime = clock.getElapsedTime();
	});
</script>

{#if uniforms}
	<T.ShaderMaterial
		side={DoubleSide}
		{vertexShader}
		{fragmentShader}
		{uniforms}
		uniforms.time.value={time}
		uniforms.windAnimationTime.value={windAnimationTime}
		uniforms.sound.value={$volume * 2}
		uniforms.glitchiness.value={$tweenedGlitchiness}
	/>
{/if}