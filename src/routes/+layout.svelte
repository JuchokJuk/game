<script lang="ts">
	import "$styles/reset.scss";
	import "$styles/global.scss";
	import { onDestroy, onMount } from "svelte";
	import { touchScreen } from "$lib/stores/touchScreen";

	let mediaQuery: MediaQueryList;

	function setTouchScreen() {
		$touchScreen = mediaQuery!.matches;
	}

	onMount(() => {
		mediaQuery = window.matchMedia("(pointer: coarse)");
		mediaQuery.addEventListener("change", setTouchScreen);

		setTouchScreen();
	});

	onDestroy(() => {
		mediaQuery?.removeEventListener("change", setTouchScreen);
	});
</script>

<slot />
