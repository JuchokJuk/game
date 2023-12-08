<script lang="ts">
	import { T, useFrame, useThrelte } from "@threlte/core";
	import { PositionalAudio, interactivity, useAudioListener, useGltf } from "@threlte/extras";
	import { quadOut } from "svelte/easing";
	import { tweened } from "svelte/motion";
	import { Vector2, type PositionalAudio as ThreePositionalAudio } from "three";
	import { volume } from "$lib/stores/volume";

	const gltf = useGltf("/Sword.glb");

	let audio: ThreePositionalAudio;
	let started = false;
	let y = 8;

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
		if (started) {
			y = 8;
			started = false;
		} else {
			y = 10;
			started = true;
		}
	}

	const tweenedY = tweened(y, {
		duration: 800,
		easing: quadOut
	});
	$: tweenedY.set(y);

	const { context } = useAudioListener();
	const analyser = context.createAnalyser();
	$: if (audio) audio.getOutput().connect(analyser);
	const pcmData = new Float32Array(analyser.fftSize);
	useFrame(() => {
		if (!audio) return;
		analyser.getFloatTimeDomainData(pcmData);
		let sumSquares = 0.0;
		for (const amplitude of pcmData) {
			sumSquares += amplitude * amplitude;
		}
		$volume = Math.sqrt(sumSquares / pcmData.length);
	});
</script>

{#await gltf then gltf}
	<T.Group position={[0, $tweenedY, 0]} scale={[1 + $volume, 1 + $volume, 1 + $volume]}>
		<T.Mesh
			geometry={gltf.nodes.Sword_mesh.geometry}
			material={gltf.materials.Metal}
			on:click={toggle}
		/>
		<T.Mesh geometry={gltf.nodes.Sword_mesh_1.geometry} material={gltf.materials.Handle} />

		{#if started}
			<PositionalAudio autoplay bind:ref={audio} refDistance={15} src={"/ICEDANCER MIXTAPE.mp3"} />
		{/if}
	</T.Group>
{/await}
