<script lang="ts">
	import { touchScreen } from "$lib/stores/touchScreen";
	import KeyboardControls from "./KeyboardControls.svelte";
	import TouchControls from "./TouchControls/TouchControls.svelte";
	import { UI } from "$lib/stores/UI";
	import { clamp } from "../clamp";
	import { joystick } from "$lib/stores/joystick";
	import { playerController } from "$lib/stores/playerController";

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

<div class="UI">
	{#if $touchScreen}
		<TouchControls {pause} />
	{:else}
		<KeyboardControls />
	{/if}
</div>

<style lang="scss">
	.UI {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
	}
</style>
