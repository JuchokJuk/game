<script lang="ts">
	import menuIcon from "$assets/icons/menu.svg?raw";
	import { scale } from "svelte/transition";
	import Button from "../Button.svelte";
	import Joystick from "./Joystick.svelte";
	import JumpButton from "./JumpButton.svelte";

	export let pause: () => void;
</script>

<div transition:scale|global={{ duration: 400, delay: 100 }} class="joystick">
	<Joystick />
</div>

<div transition:scale|global={{ duration: 400, delay: 100 * 2 }} class="jump">
	<JumpButton />
</div>

<div transition:scale|global={{ duration: 400, delay: 100 * 3 }} class="menu">
	<Button on:click={pause} on:touchend={pause} type="icon">
		{@html menuIcon}
	</Button>
</div>

<style lang="scss">
	.menu {
		position: absolute;
		top: 48px;
		right: 48px;
	}

	.joystick {
		position: absolute;
		bottom: 48px;
		left: 48px;
	}

	.jump {
		position: absolute;
		bottom: 48px + 64px - 32px;
		right: 48px + 64px - 32px;
	}
</style>
