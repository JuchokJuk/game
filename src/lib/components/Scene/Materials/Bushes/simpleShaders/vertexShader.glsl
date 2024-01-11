varying vec2 vUv;
varying vec3 position_;

void main() {
  vUv = uv;

  vec4 mvPosition = vec4( position, 1.0 );
  vec4 modelViewPosition = modelViewMatrix * mvPosition;
  position_ = position;

  gl_Position = projectionMatrix * modelViewPosition;
}