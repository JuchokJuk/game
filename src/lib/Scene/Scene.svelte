<script lang="ts">
	import { Debug } from '@threlte/rapier';
	import Player from '../Player/Player.svelte';
	import Light from '../Light/Light.svelte';
	import Terrain from '../Terrain/Terrain.svelte';
	import { Color, Fog, Mesh, MeshBasicMaterial, MeshStandardMaterial, Uniform } from 'three';

	import fragmentShader from './simpleShaders/fragmentShader.glsl?raw';

	import { T, useThrelte } from '@threlte/core';

	import { useRender } from '@threlte/core';
	import {
		EffectComposer,
		EffectPass,
		RenderPass,
		BloomEffect,
		DepthOfFieldEffect,
		Effect
	} from 'postprocessing';
	import Fireflies from '../Fireflies/Fireflies.svelte';
	import Sky from '../Sky/Sky.svelte';
	import Music from '../Music/Music.svelte';
	import { rendererStore } from './rendererStore';
	import Face from '$lib/Face/Face.svelte';

	const { scene, renderer, camera, size } = useThrelte();

	$rendererStore = renderer;
	scene.background = new Color('rgb(16, 64, 64)');
	scene.fog = new Fog('rgb(16, 64, 64)', 0, 120);

	// ---- ---- ---- ---- //

	const composer = new EffectComposer(renderer);

	function setupEffectComposer(camera: any) {
		composer.removeAllPasses();
		composer.addPass(new RenderPass(scene, camera));
		// composer.addPass(
		// 	new EffectPass(
		// 		camera,
		// 		new DepthOfFieldEffect(camera, {
		// 			focusDistance: 0.0,
		// 			focusRange: 0.1,
		// 			bokehScale: 4,
		// 			resolutionScale: 0.5
		// 		})
		// 	)
		// );
		composer.addPass(
			new EffectPass(
				camera,
				new BloomEffect({
					luminanceThreshold: 0.8,
					luminanceSmoothing: 0.025,
					mipmapBlur: true,
					intensity: 4,
					radius: 0.85,
					levels: 4
				})
			)
		);
		// composer.addPass(
		// 	new EffectPass(
		// 		camera,
		// 		new Effect(
		// 			'custom',
		// 			fragmentShader,
		// 			// { uniforms: new Map([['index', new Uniform(1)]]) }
		// 		)
		// 	)
		// );
	}

	$: setupEffectComposer($camera);
	$: composer.setSize($size.width, $size.height);

	useRender((ctx, delta) => {
		composer.render(delta);
	});
</script>

<!-- <Debug /> -->

<!-- <Sky /> -->

<Terrain />

<Light />

<Fireflies />

<Player position={[0, 8, 0]} />

<!-- <Face /> -->

<!-- <Music /> -->
