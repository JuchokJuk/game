varying vec2 vUv;
uniform float time;
#include <fog_pars_vertex>

void main() {
  #include <begin_vertex>
  #include <project_vertex>
  #include <fog_vertex>

  vUv = uv;

  vec4 mvPosition_ = vec4( position, 1.0 );

  #ifdef USE_INSTANCING
    mvPosition_ = instanceMatrix * mvPosition_;
  #endif

  float dispPower = 1.0 - cos( uv.y * 3.1416 / 2.0 );

  float displacement = sin( mvPosition_.y + time) * ( 0.1 * dispPower );
  mvPosition_.y += displacement;

  vec4 modelViewPosition = modelViewMatrix * mvPosition_;
  gl_Position = projectionMatrix * modelViewPosition;
}