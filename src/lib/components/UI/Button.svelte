<script lang="ts">
	export let type: undefined | "icon";
</script>

<button on:click on:touchend class={type}>
	<slot />
</button>

<style lang="scss">
	@import "$styles/hover";

	button {
		cursor: pointer;
		border: none;

		transition: transform 0.2s;

		@include hover {
			transform: scale(1.2);
		}

		&:active {
			transform: scale(0.8);
		}

		&:focus {
			outline: none;
		}

		&.icon {
			background: none;
		}
	}
</style>
