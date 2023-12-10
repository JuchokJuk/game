<script lang="ts">
	import { useFrame } from "@threlte/core";
	import { PositionalAudio, useAudioListener } from "@threlte/extras";
	import type { PositionalAudio as ThreePositionalAudio } from "three";
	import { volume } from "$lib/stores/volume";
	import SecondOrderDynamics from "../../SecondOrderDynamics";

	let audio: ThreePositionalAudio;

	const { context } = useAudioListener();
	const analyser = context.createAnalyser();
	$: if (audio) audio.getOutput().connect(analyser);
	const pcmData = new Float32Array(analyser.fftSize);

	const smoothVolume = new SecondOrderDynamics(8, 1, 0);

	useFrame((_ctx, delta) => {
		if (!audio) return;
		analyser.getFloatTimeDomainData(pcmData);
		let sumSquares = 0.0;
		for (const amplitude of pcmData) {
			sumSquares += amplitude * amplitude;
		}
		smoothVolume.update(delta, Math.sqrt(sumSquares / pcmData.length));
		$volume = smoothVolume.value;
	});
</script>

<PositionalAudio autoplay bind:ref={audio} refDistance={15} src={"audio/Bullets.mp3"} />
