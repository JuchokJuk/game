varying vec2 vUv;
uniform float time;
uniform sampler2D treesTexture;
uniform sampler2D glitchedTexture;
uniform float glitchiness;

void main() {	
	vec4 initialColor = texture2D(treesTexture, vUv);
	vec4 glitchedColor = texture2D(glitchedTexture, vUv);

    gl_FragColor = vec4(mix(initialColor, glitchedColor, glitchiness));
}