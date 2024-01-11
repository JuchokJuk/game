<script lang="ts">
	import Light from "./Light.svelte";
	import Terrain from "./Terrain.svelte";
	import Fireflies from "./Fireflies.svelte";
	import Sky from "./Sky/Sky.svelte";
	import { SphereGeometry } from "three";
	import type { Camera } from "three";

	import grain from "./simpleShaders/grain.glsl?raw";
	import chromaticAberration from "./simpleShaders/chromaticAberration.glsl?raw";

	import { T, useThrelte } from "@threlte/core";
	import { useRender } from "@threlte/core";

	import { EffectComposer, EffectPass, RenderPass, BloomEffect, Effect } from "postprocessing";
	import Sword from "./Sword/Sword.svelte";
	import { renderer as rendererStore } from "$lib/stores/renderer";
	import Player from "./Player.svelte";
	import { users } from "$lib/stores/users";
	import White from "./Materials/White/White.svelte";
	import { Float } from "@threlte/extras";

	const { scene, renderer, camera, size } = useThrelte();
	$rendererStore = renderer;

	const composer = new EffectComposer(renderer);

	function setupEffectComposer(camera: Camera) {
		composer.removeAllPasses();
		composer.addPass(new RenderPass(scene, camera));
		// composer.addPass(
		// 	new EffectPass(
		// 		camera,
		// 		new DepthOfFieldEffect(camera, {
		// 			focusDistance: 0.0,
		// 			focusRange: 0.01,
		// 			bokehScale: 4,
		// 			resolutionScale: 0.5
		// 		})
		// 	)
		// );
		composer.addPass(new EffectPass(camera, new Effect("custom", chromaticAberration)));
		composer.addPass(new EffectPass(camera, new Effect("custom", grain)));
		composer.addPass(
			new EffectPass(
				camera,
				new BloomEffect({
					luminanceThreshold: 0.8,
					luminanceSmoothing: 0.025,
					mipmapBlur: true,
					intensity: 2,
					radius: 0.85,
					levels: 4
				})
			)
		);
	}

	$: setupEffectComposer($camera);
	$: composer.setSize($size.width, $size.height);

	useRender((_ctx, delta) => {
		composer.render(delta);
	});
</script>

{#each $users as user (user.UUID)}
	<Float speed={4}>
		<T.Mesh
			geometry={new SphereGeometry(0.5, 8, 8)}
			position={user.position && [user.position[0], user.position[1] + 0.75, user.position[2]]}
		>
			<White />
		</T.Mesh>
	</Float>
{/each}

<Player position={[-20, 0, 20]} />
<Terrain />
<Fireflies />
<Light />
<Sky />
<Sword />
