varying vec2 vUv;
uniform sampler2D initialTexture;
uniform float glitchiness;

void main() {	
	vec4 initialColor = texture2D(initialTexture, vUv);

    gl_FragColor = vec4(mix(initialColor, vec4(initialColor.rgb, 0.0), glitchiness));
}