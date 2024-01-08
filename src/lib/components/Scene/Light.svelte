<script lang="ts">
	import { T } from "@threlte/core";
</script>

<T.AmbientLight color={[0.25, 0.25, 0.8]} intensity={1} />
<!-- blue -->
<T.PointLight
	position={[35, -50, 15]}
	color={[0.125, 0.125, 1]}
	intensity={2000}
	autoUpdate={false}
/>
<!-- red -->
<T.PointLight
	position={[-45, -20, 10]}
	color={[1, 0.25, 0.25]}
	intensity={2000}
	autoUpdate={false}
/>
<!-- white -->
<T.PointLight position={[15, 60, 10]} color={[1, 1, 1]} intensity={2000} autoUpdate={false} />
<!-- yellow -->
<T.PointLight
	position={[4, -6, -21]}
	color={[0.75, 0.75, 0.125]}
	intensity={2000}
	autoUpdate={false}
/>
<!-- 
	shadow.camera.far={128}
	shadow.camera.bottom={-90}
	shadow.camera.top={90}
	shadow.camera.left={-90}
	shadow.camera.right={90}
	shadow.mapSize.x={1024}
	shadow.mapSize.y={1024}
	shadow.bias={-0.005}
 -->
