<script lang="ts">
	import { T } from "@threlte/core";

	import fragmentShader from "./simpleShaders/fragmentShader.glsl?raw";
	import vertexShader from "./simpleShaders/vertexShader.glsl?raw";
</script>

<T.ShaderMaterial {vertexShader} {fragmentShader} />
