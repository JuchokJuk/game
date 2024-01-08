<script lang="ts">
	import { Canvas } from "@threlte/core";
	import Scene from "$lib/components/Scene/Scene.svelte";
	import { UI as UIstore } from "$lib/stores/UI";
	import { fade, scale } from "svelte/transition";
	import playIcon from "$assets/icons/triangle.svg?raw";
	import UI from "$lib/components/UI/UI.svelte";
	import Button from "$lib/components/UI/Button.svelte";
	import { World } from "@threlte/rapier";
	import { useProgress } from "@threlte/extras";
	import { tweened } from "svelte/motion";
	import { renderer } from "$lib/stores/renderer";
	import Multiplayer from "$lib/components/Multiplayer/Multiplayer.svelte";

	let delayed = true;

	function play() {
		$renderer.domElement.requestPointerLock();
		document.documentElement.requestFullscreen();

		$UIstore = "playing";
	}

	function pause() {
		$UIstore = "waiting";
		document.exitFullscreen();
		if (document.fullscreenElement !== null) document.exitPointerLock();
	}

	function pointerLockChange() {
		if (document.pointerLockElement === $renderer.domElement) {
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

	$: if ($progress === 1) {
		gravity = [0, -9.81, 0];
	}

	let gravity: [number, number, number] = [0, 0, 0];
</script>

<svelte:document on:pointerlockchange={pointerLockChange} />

<div class="canvas" class:blurred={$UIstore === "waiting"}>
	<Canvas>
		<World {gravity}>
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

<Multiplayer />

<style lang="scss">
	@import "$styles/colors";

	.canvas {
		height: 100%;
		transition: 0.4s filter;

		&.blurred {
			filter: blur(8px);
		}
	}

	.overlay {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background: $black;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		transition: 0.4s background-color;

		&.loaded {
			background: rgba($black, 0.5);
		}
	}

	.bar-wrapper {
		width: 256px;
		height: 4px;
		background: rgba($white, 0.5);
		overflow: hidden;
		border-radius: 2px;
		position: relative;
	}
	.bar {
		height: 100%;
		background: $white;
	}
</style>
