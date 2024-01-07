<script lang="ts">
	import { T, useFrame, useLoader } from "@threlte/core";
	import { DoubleSide, SRGBColorSpace, TextureLoader } from "three";

	import fragmentShader from "./simpleShaders/fragmentShader.glsl?raw";
	import vertexShader from "./simpleShaders/vertexShader.glsl?raw";
	import { volume } from "$lib/stores/volume";

	let time = 0;
	let uniforms: { [key: string]: any };

	const texture = useLoader(TextureLoader).load("models/Terrain denoised/Grass baked.png");

	texture.then((texture) => {
		texture.flipY = false;
		texture.colorSpace = SRGBColorSpace;
		uniforms = {
			time: { value: time },
			sound: { value: 0 },
			grassTexture: { value: texture }
		};
	});

	useFrame(({ clock }) => {
		time = clock.getElapsedTime();
	});
</script>

{#if uniforms}
	<T.ShaderMaterial
		side={DoubleSide}
		{vertexShader}
		{fragmentShader}
		{uniforms}
		uniforms.time.value={time}
		uniforms.sound.value={$volume * 2}
	/>
{/if}
