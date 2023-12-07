<script lang="ts">
	import { Canvas } from "@threlte/core";
	import Scene from "$lib/components/Scene/Scene.svelte";
	import { UI as UIstore } from "$lib/stores/UI";
	import { fade, scale } from "svelte/transition";
	import playIcon from "$assets/triangle.svg?raw";
	import UI from "$lib/components/UI/UI.svelte";
	import Button from "$lib/components/UI/Button.svelte";
	import { World } from "@threlte/rapier";
	import { useProgress } from "@threlte/extras";
	import { tweened } from "svelte/motion";

	let delayed = true;

	function play() {
		document.documentElement.requestPointerLock();
		document.documentElement.requestFullscreen();

		$UIstore = "playing";
	}

	function pause() {
		$UIstore = "waiting";
		document.exitFullscreen();
		if (document.fullscreenElement !== null) document.exitPointerLock();
	}

	function lockChangeAlert() {
		if (document.pointerLockElement === document.documentElement) {
			$UIstore = "playing";
			delayed = false;
		} else {
			$UIstore = "waiting";
			if (document.fullscreenElement !== null) document.exitFullscreen();
			setTimeout(() => {
				delayed = true;
			}, 1000);
		}
	}

	const { progress } = useProgress();
	const tweenedProgress = tweened($progress, {
		duration: 800
	});
	$: tweenedProgress.set($progress);
</script>

<svelte:document on:pointerlockchange={lockChangeAlert} />

<div class="canvas" class:blurred={$UIstore === "waiting"}>
	<Canvas>
		<World>
			<Scene />
			<!-- <Debug/> -->
		</World>
	</Canvas>
</div>

{#if $UIstore === "playing"}
	<UI {pause} />
{:else}
	<div class="overlay" class:loaded={$tweenedProgress === 1} transition:fade={{ duration: 400 }}>
		{#if $tweenedProgress < 1}
			<div class="bar-wrapper">
				<div class="bar" style="width: {$tweenedProgress * 100}%" />
			</div>
		{:else if delayed}
			<div transition:scale|global={{ duration: 400 }}>
				<Button on:click={play} on:touchend={play} type="icon">
					{@html playIcon}
				</Button>
			</div>
		{/if}
	</div>
{/if}

<style lang="scss">
	@import "$styles/colors";

	.canvas {
		height: 100%;
		transition: 0.4s filter;

		&.blurred {
			filter: blur(8px);
		}

		// :global(canvas) {
		// 	filter: hue-rotate(150deg);
		// }
	}

	.overlay {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background: $black;
		display: flex;
		align-items: center;
		justify-content: center;
		transition: 0.4s background-color;

		&.loaded {
			background: rgba($black, 0.5);
		}
	}

	.wrapper {
		position: absolute;
		width: 100%;
		height: 100%;
		top: 0;
		left: 0;
		background-color: $black;
		display: flex;
		align-items: center;
		justify-content: center;
	}
	.bar-wrapper {
		width: 256px;
		height: 16px;
		border: 2px solid $white;
		position: relative;
	}
	.bar {
		height: 100%;
		background-color: $white;
	}
</style>