<script lang="ts">
	import { T, useFrame } from '@threlte/core';
	import { Edges} from '@threlte/extras';
	export let discSpeed = 0;
	let discRotation = 0;
	const { start, stop, started } = useFrame(
		() => {
			discRotation += 0.02 * discSpeed;
		},
		{
			autostart: false
		}
	);
	$: {
		if (discSpeed <= 0 && $started) stop();
		else if (discSpeed > 0 && !$started) start();
	}
</script>

<T.Group {...$$restProps}>
	<T.Group rotation.y={-discRotation}>
		<!-- DISH (?) -->
		<T.Mesh receiveShadow castShadow position.y={0.1}>
			<T.CylinderGeometry args={[1.85, 2, 0.2, 64]} />
			<T.MeshStandardMaterial color={[0.06640625, 0.06640625, 0.06640625]} />
			<Edges color="black" thresholdAngle={20} />
		</T.Mesh>
		<!-- ACTUAL DISC -->
		<T.Mesh receiveShadow castShadow position.y={0.2 + 0.05}>
			<T.CylinderGeometry args={[1.75, 1.75, 0.05, 64]} />
			<T.MeshStandardMaterial color={[0.06640625, 0.06640625, 0.06640625]} />
			<Edges thresholdAngle={50} scale={1} color="black" />
		</T.Mesh>
		<!-- ROUND LABEL -->
		<T.Mesh receiveShadow castShadow position.y={0.2 + 0.05 + 0.005}>
			<T.CylinderGeometry args={[0.8, 0.8, 0.05, 64]} />
			<T.MeshStandardMaterial color={[0.9296875, 0.85546875, 0.79296875]} />
			<Edges thresholdAngle={50} scale={1} color="black" />
		</T.Mesh>
	</T.Group>
</T.Group>
