<script lang="ts">
	import Light from "./Light.svelte";
	import Terrain from "./Terrain.svelte";
	import Fireflies from "./Fireflies/Fireflies.svelte";
	import Sky from "./Sky/Sky.svelte";
	import type { Camera } from "three";

	// import noise from "./simpleShaders/noise.glsl?raw";
	import grain from "./simpleShaders/grain.glsl?raw";
	import chromaticAberration from "./simpleShaders/chromaticAberration.glsl?raw";

	import { useThrelte } from "@threlte/core";
	import { useRender } from "@threlte/core";

	import {
		EffectComposer,
		EffectPass,
		RenderPass,
		BloomEffect,
		Effect

		// DepthOfFieldEffect
	} from "postprocessing";
	import Sword from "./Sword.svelte";
	import { renderer as rendererStore } from "$lib/stores/renderer";
	import Player from "./Player.svelte";

	const { scene, renderer, camera, size } = useThrelte();
	$rendererStore = renderer;

	// scene.background = new Color("rgb(102, 102, 204)");
	// scene.fog = new Fog("rgb(102, 102, 204)", 0, 64);

	const composer = new EffectComposer(renderer);

	function setupEffectComposer(camera: Camera) {
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
		composer.addPass(new EffectPass(camera, new Effect("custom", grain)));
		composer.addPass(new EffectPass(camera, new Effect("custom", chromaticAberration)));
	}

	$: setupEffectComposer($camera);
	$: composer.setSize($size.width, $size.height);

	useRender((_ctx, delta) => {
		composer.render(delta);
	});
</script>

<Player position={[0, 0, 28]} />
<Terrain />
<Fireflies />
<Light />
<Sky />
<Sword />
