// CUSTOM SHADER PARAMS BEGIN
varying vec2 vUv;
uniform float time;
// CUSTOM SHADER PARAMS END

varying vec3 vViewPosition;

#ifdef USE_TRANSMISSION

	varying vec3 vWorldPosition;

#endif

#include <common>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

	#include <uv_vertex>
	#include <color_vertex>
	#include <morphcolor_vertex>

	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>

	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>

	vViewPosition = - mvPosition.xyz;

	#include <worldpos_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>

  // CUSTOM SHADER BEGIN
  vUv = uv;

  vec4 mvPosition_ = vec4( position, 1.0 );

  #ifdef USE_INSTANCING
    mvPosition_ = instanceMatrix * mvPosition_;
  #endif

  float dispPower = 1.0 - cos( uv.y * 3.1416 / 2.0 );

  float displacement = sin( mvPosition_.y + time * 4.0 ) * ( 0.1 * dispPower );
  mvPosition_.y += displacement;

  vec4 modelViewPosition = modelViewMatrix * mvPosition_;
  gl_Position = projectionMatrix * modelViewPosition;
  // CUSTOM SHADER END

  #ifdef USE_TRANSMISSION
    vWorldPosition = worldPosition.xyz;
  #endif

}