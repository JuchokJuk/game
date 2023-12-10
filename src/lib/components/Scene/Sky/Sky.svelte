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

	let uniforms = {
		time: { value: time },
		opacity: { value: 0 }
	};

	useFrame(({ clock }) => {
		time = clock.getElapsedTime();
	});

	const tweenedOpacity = tweened(0, {
		duration: 800,
		easing: quadOut
	});

	$: if ($musicStarted) {
		$tweenedOpacity = 1;
	} else {
		$tweenedOpacity = 0;
	}

	let y = 8;

	$: if ($musicStarted) {
		y = 12;
	} else {
		y = 8;
	}

	const tweenedY = tweened(y, {
		duration: 800,
		easing: quadOut
	});

	$: $tweenedY = y;
</script>

<T.Mesh
	rotation={[$swordRotation, $swordRotation, $swordRotation]}
	scale={$tweenedOpacity + 0.5}
	position={[0, $tweenedY, 0]}
>
	<T.SphereGeometry args={[-20 * 10, 32]} />
	<T.ShaderMaterial
		{vertexShader}
		{fragmentShader}
		{uniforms}
		transparent
		uniforms.time.value={time + $volume * 8}
		uniforms.opacity.value={$tweenedOpacity}
	/>
</T.Mesh>
