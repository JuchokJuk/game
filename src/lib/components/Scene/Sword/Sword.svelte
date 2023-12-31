<script lang="ts">
	import { T, useFrame, useThrelte } from "@threlte/core";
	import { interactivity, useGltf } from "@threlte/extras";
	import { quadOut } from "svelte/easing";
	import { tweened } from "svelte/motion";
	import { Vector2 } from "three";
	import { volume } from "$lib/stores/volume";
	import Audio from "./Audio.svelte";
	import { musicStarted } from "$lib/stores/musicStarted";
	import SwordSound from "./SwordSound.svelte";
	import { swordRotation } from "$lib/stores/swordRotation";
	import { broadcast } from "$lib/utils/broadcast";

	const gltf = useGltf("models/Sword.glb");

	const { camera } = useThrelte();

	interactivity({
		compute: (_event, state) => {
			state.pointer.update(() => {
				return new Vector2(0, 0);
			});
			state.raycaster.setFromCamera(state.pointer.current, $camera);
		},

		filter: (hits) => {
			return hits.slice(0, 1);
		}
	});

	function toggle() {
		if ($musicStarted) {
			$musicStarted = false;
		} else {
			$musicStarted = true;
		}

		broadcast({
			action: "toggleMusic",
			payload: $musicStarted
		});
	}

	let y = 8;

	const tweenedY = tweened(y, {
		duration: 800,
		easing: quadOut
	});

	$: $tweenedY = y;

	let angleX = 0;
	let angleY = 0;

	const tweenedAngleX = tweened(angleX, {
		duration: 800,
		easing: quadOut
	});
	const tweenedAngleY = tweened(angleY, {
		duration: 800,
		easing: quadOut
	});

	useFrame((_ctx, delta) => {
		if ($musicStarted) {
			angleX = angleX + delta * 0.02;
			angleY = angleY + delta * 0.02;
		} else {
			angleX = 0;
			angleY = 0;
		}

		$tweenedAngleX = Math.cos(angleX);
		$tweenedAngleY = Math.sin(angleY);
	});

	$: {
		$swordRotation = Math.atan2($tweenedAngleY, $tweenedAngleX);
	}

	$: {
		if ($musicStarted) {
			y = 12;
		} else {
			y = 8;
		}
	}
</script>

{#await gltf then gltf}
	<T.Group
		position={[0, $tweenedY, 0]}
		rotation={[$swordRotation, $swordRotation, $swordRotation]}
		scale={[1 + $volume, 1 + $volume, 1 + $volume]}
		on:click={toggle}
	>
		<T.Mesh geometry={gltf.nodes.Sword_mesh.geometry} material={gltf.materials.Metal} />
		<T.Mesh geometry={gltf.nodes.Sword_mesh_1.geometry} material={gltf.materials.Handle} />

		{#if $musicStarted}
			<SwordSound />
			<Audio />
		{/if}
	</T.Group>
{/await}
