<script lang="ts">
	import { T, useFrame } from '@threlte/core';
	import { PlaneGeometry, DoubleSide, UniformsUtils, ShaderLib } from 'three';
	import { DEG2RAD } from 'three/src/math/MathUtils';

	import fragmentShader from './fragmentShader.glsl?raw';
	import vertexShader from './vertexShader.glsl?raw';

	let time = 0;

	let uniforms = UniformsUtils.merge([
		ShaderLib.standard.uniforms,
		{
			opacity: { value: 0.5 },
			roughness: { value: 0.5 },
			metalness: { value: 1 },
			time: { value: time }
		}
	]);

	useFrame(({ clock }) => {
		time = clock.getElapsedTime();
	});
</script>

<T.Mesh
	geometry={new PlaneGeometry(400, 400, 64, 64)}
	rotation={[-90 * DEG2RAD, 0, 0]}
	position={[0, 0, 0]}
>
	<T.ShaderMaterial
		side={DoubleSide}
		{vertexShader}
		{fragmentShader}
		{uniforms}
		uniforms.time.value={time}
		fog
		lights
		transparent
	/>
</T.Mesh>
