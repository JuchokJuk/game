<script lang="ts">
	import { touchScreen } from "$lib/stores/touchScreen";
	import KeyboardControls from "./KeyboardControls.svelte";
	import TouchControls from "./TouchControls/TouchControls.svelte";
	import { UI } from "$lib/stores/UI";
	import { clamp } from "../clamp";
	import { joystick } from "$lib/stores/joystick";
	import { playerController } from "$lib/stores/playerController";
	import { scale } from "svelte/transition";

	export let pause: () => void;

	function onPointerMove(event: PointerEvent) {
		if ($UI === "waiting" || event.target === $joystick) return;

		const xh = event.movementX * 0.003;
		const yh = event.movementY * 0.003;

		$playerController.phi += -xh * 1;
		$playerController.theta = clamp($playerController.theta + -yh * 1, -Math.PI / 2, Math.PI / 2);
	}
</script>

<svelte:window on:pointermove={onPointerMove} />

{#if $touchScreen}
	<TouchControls {pause} />
{:else}
	<KeyboardControls />
{/if}
<!-- <div class="cursor" transition:scale|global={{ duration: 400 }} /> -->

<style lang="scss">
	// .cursor {
	// 	background-color: white;

	// 	mix-blend-mode: difference;
	// 	width: 4px;
	// 	height: 4px;
	// 	border-radius: 2px;

	// 	position: fixed;
	// 	top: 50%;
	// 	left: 50%;
	// 	transform: translate(-50%, -50%);
	// }
</style>
