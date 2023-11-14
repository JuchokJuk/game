<script lang="ts">
	import { T } from '@threlte/core';

	import fragmentShader from './simpleShaders/fragmentShader.glsl?raw';
	import vertexShader from './simpleShaders/vertexShader.glsl?raw';
</script>

<T.AmbientLight color={[1, 1, 1]} intensity={0.1} />
<T.DirectionalLight
	position={[100, 32, 100]}
	color={[1, 1, 1]}
	intensity={0.1}
	castShadow
	shadow.camera.far={512}
	shadow.camera.bottom={-90}
	shadow.camera.top={90}
	shadow.camera.left={-90}
	shadow.camera.right={90}
	shadow.mapSize.x={4096}
	shadow.mapSize.y={4096}
/>

<T.Mesh position={[512, 64, 512]}>
	<T.SphereGeometry args={[32, 16, 16]} />
	<T.ShaderMaterial {vertexShader} {fragmentShader} />
</T.Mesh>
