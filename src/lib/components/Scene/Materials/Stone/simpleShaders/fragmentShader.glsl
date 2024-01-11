varying vec2 vUv;
uniform sampler2D initialTexture;
uniform sampler2D glitchedTexture;
uniform float glitchiness;

void main() {	
	vec4 initialColor = texture2D(initialTexture, vUv);
	vec4 glitchedColor = texture2D(glitchedTexture, vUv);

    gl_FragColor = vec4(mix(initialColor, glitchedColor, glitchiness));
}