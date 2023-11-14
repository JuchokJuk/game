varying vec2 vUv;
#include <fog_pars_fragment>

void main() {
    vec3 diffuse = vec3(0., 1., 0.);
    float clarity = ( vUv.y * 0.5 ) + 0.5;
    diffuse *= clarity;
	gl_FragColor = vec4(diffuse*0.2, 1.);
    #include <fog_fragment>
}