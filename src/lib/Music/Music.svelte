<script lang="ts">
	import { T, useThrelte } from '@threlte/core';
	import { interactivity } from '@threlte/extras';
	import { spring } from 'svelte/motion';
	import { DEG2RAD } from 'three/src/math/MathUtils';
	import Speaker from './Speaker.svelte';
	import Turntable from './TurnTable.svelte';
	import { Vector2 } from 'three';

	let volume = 0;
	let isPlaying = false;

	const smoothVolume = spring(0);
	$: smoothVolume.set(volume);

	const { camera } = useThrelte();

	interactivity({
		compute: (event, state) => {
			state.pointer.update(() => {
				return new Vector2(0, 0);
			});
			state.raycaster.setFromCamera(state.pointer.current, $camera);
		},

		filter: (hits) => {
			// only return first hit, we don't care
			// about propagation in this example
			return hits.slice(0, 1);
		}
	});
</script>

<T.Group position={[0, 6, 8]}>
	<Turntable bind:isPlaying bind:volume />

	<Speaker position.x={6} rotation.y={DEG2RAD * -7} {volume} />
	<Speaker position.x={-6} rotation.y={DEG2RAD * 7} {volume} />
</T.Group>
