varying vec2 vUv;
uniform float time;

void main() {
  vUv = uv;

  vec4 mvPosition = vec4( position, 1.0 );
  vec4 modelViewPosition = modelViewMatrix * mvPosition;

  gl_Position = projectionMatrix * modelViewPosition;
}