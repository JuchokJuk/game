<script lang="ts">
	import { T, forwardEventHandlers } from '@threlte/core';
	import { Edges, Text, useCursor } from '@threlte/extras';
	import { spring } from 'svelte/motion';
	import { Color } from 'three';
	import { DEG2RAD } from 'three/src/math/MathUtils';
	export let text: string;
	const buttonOffsetY = spring(0);
	let buttonColor: [number, number, number] = [0.0666, 0.0666, 0.0666];
	let textColor: [number, number, number] = [0.9296875, 0.85546875, 0.79296875];
	const { onPointerEnter, onPointerLeave } = useCursor();
	const component = forwardEventHandlers();
</script>

<T.Group {...$$restProps}>
	<T.Group position.y={0.05 - $buttonOffsetY}>
		<T.Mesh
			bind:this={$component}
			on:pointerenter={(e) => {
				e.stopPropagation();
				buttonColor = [0.9296875, 0.85546875, 0.79296875];
				textColor = [0.0666, 0.0666, 0.0666];
				onPointerEnter();
			}}
			on:pointerleave={(e) => {
				e.stopPropagation();
				buttonColor = [0.0666, 0.0666, 0.0666];
				textColor = [0.9296875, 0.85546875, 0.79296875];
				buttonOffsetY.set(0);
				onPointerLeave();
			}}
			on:pointerdown={(e) => {
				e.stopPropagation();
				buttonOffsetY.set(0.05);
			}}
			on:pointerup={(e) => {
				e.stopPropagation();
				buttonOffsetY.set(0);
			}}
		>
			<T.BoxGeometry args={[1.2, 0.1, 0.8]} />
			<T.MeshStandardMaterial color={buttonColor} />
			<Edges
				color="black"
				raycast={() => {
					return false;
				}}
			/>
		</T.Mesh>
		<Text
			renderOrder={-100}
			ignorePointer
			color={new Color(...textColor)}
			{text}
			rotation.x={DEG2RAD * -90}
			position.y={0.055}
			fontSize={0.35}
			anchorX="50%"
			anchorY="50%"
		/>
	</T.Group>
</T.Group>
