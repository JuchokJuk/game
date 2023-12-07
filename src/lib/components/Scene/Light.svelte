<script lang="ts">
	import { T } from "@threlte/core";
</script>

<T.AmbientLight color={[1, 1, 1]} intensity={0.1} />
<T.PointLight
	position={[32, 32, 32]}
	color={[1, 1, 1]}
	intensity={1000}
	shadow.camera.far={128}
	shadow.camera.bottom={-90}
	shadow.camera.top={90}
	shadow.camera.left={-90}
	shadow.camera.right={90}
	shadow.mapSize.x={2048}
	shadow.mapSize.y={2048}
	shadow.bias={-0.005}
	castShadow
	autoUpdate={false}
/>
