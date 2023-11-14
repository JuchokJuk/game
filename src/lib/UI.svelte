<script lang="ts">
	import {
		jump,
		run,
		doubleForwardRun,
		forward,
		backward,
		left,
		right
	} from './Player/controlsStore';

	let forwardPressed = false;

	function wDown() {
		$forward = 1;
		if (forwardPressed) {
			$doubleForwardRun = 1;
		}
	}

	function wUp() {
		$forward = 0;
		$doubleForwardRun = 0;
		forwardPressed = true;
		setTimeout(() => {
			forwardPressed = false;
		}, 200);
	}

	function aDown() {
		$left = 1;
	}
	function aUp() {
		$left = 0;
	}

	function sDown() {
		$backward = 1;
	}
	function sUp() {
		$backward = 0;
	}

	function dDown() {
		$right = 1;
	}
	function dUp() {
		$right = 0;
	}

	function jumpDown() {
		$jump = 1;
	}
	function jumpUp() {
		$jump = 0;
	}

	function runDown() {
		$run = 1;
	}

	function runUp() {
		$run = 0;
		$doubleForwardRun = 0;
	}
</script>

<div class="pointer-container">
	<div class="vertical" />
	<div class="horizontal" />
</div>

<!-- <div class="ui">
	<button on:pointerdown={wDown} on:pointerup={wUp}>W</button>
	<div class="row">
		<button on:pointerdown={aDown} on:pointerup={aUp}>A</button>
		<button on:pointerdown={sDown} on:pointerup={sUp}>S</button>
		<button on:pointerdown={dDown} on:pointerup={dUp}>D</button>
	</div>
	<button class="full-width" on:pointerdown={jumpDown} on:pointerup={jumpUp}>Jump</button>
	<button class="full-width" on:pointerdown={runDown} on:pointerup={runUp}>Run</button>
</div> -->

<style lang="scss">
	.ui {
		user-select: none;
		position: fixed;
		bottom: 32px;
		left: 32px;

		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 8px;

		.row {
			display: flex;
			gap: 8px;
		}

		button {
			display: block;
			width: 32px;
			height: 32px;

			display: flex;
			align-items: center;
			justify-content: center;
		}

		.full-width {
			width: 100%;
		}
	}

	.pointer-container {
		position: fixed;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);

		display: flex;
		align-items: center;
		justify-content: center;
		mix-blend-mode: difference;

		.vertical {
			position: absolute;
			height: 1px;
			width: 16px;
			background: #ffffff;
		}
		.horizontal {
			position: absolute;
			height: 16px;
			width: 1px;
			background: #ffffff;
		}
	}
</style>
