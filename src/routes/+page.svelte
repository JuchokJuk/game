<script lang="ts">
	import { rendererStore } from '$lib/Scene/rendererStore';
	import { Canvas } from '@threlte/core';
	import { World } from '@threlte/rapier';
	import Scene from '$lib/Scene/Scene.svelte';
	import UI from '$lib/UI.svelte';
	// import Actor from '$lib/Actor/Actor.svelte';

	let playing = false;
	let delayed = true;

	async function play() {
		$rendererStore.domElement.requestPointerLock();
		history.pushState(null, '', location.href);
		playing = true;
	}

	function payse() {
		playing = false;
	}

	function lockChangeAlert() {
		if (document.pointerLockElement === $rendererStore.domElement) {
			playing = true;
			delayed = false;
		} else {
			playing = false;
			setTimeout(() => {
				delayed = true;
			}, 1000);
		}
	}
</script>

<svelte:window on:popstate={payse} />
<svelte:document on:pointerlockchange={lockChangeAlert} />

<!-- rendererParameters={{ preserveDrawingBuffer: true }} -->
<Canvas>
	<World>
		<Scene />
	</World>
</Canvas>

<!-- <Actor/> -->

{#if playing}
	<UI />
{:else}
	<div class="overlay">
		{#if delayed}
			<button on:click={play}>play</button>
		{/if}
	</div>
{/if}

<style lang="scss">
	.overlay {
		height: 100%;
		width: 100%;
		background: rgba(0, 0, 0, 0.8);

		position: fixed;
		top: 0;

		display: flex;
		align-items: center;
		justify-content: center;

		color: white;

		button {
			padding: 8px;
		}
	}
</style>
