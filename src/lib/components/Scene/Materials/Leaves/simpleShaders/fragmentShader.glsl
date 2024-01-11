varying vec2 vUv;
varying vec3 position_;
uniform float time;
uniform sampler2D treesTexture;
uniform float glitchiness;

void main() {	
	vec4 initialColor = texture2D(treesTexture, vUv);

    gl_FragColor = vec4(mix(initialColor, vec4(initialColor.rgb, 0.0), glitchiness));
}