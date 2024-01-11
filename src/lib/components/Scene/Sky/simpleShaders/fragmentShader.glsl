varying vec2 vUv;
uniform float time;
uniform float glitchiness;

vec3 palette( float t ) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.163,0.116,0.157);

    return a + b*cos( 6.28318*(c*t+d) );
}

void main() {
    vec3 initialColor = vec3(0.125, 0.125, 0.5);

	vec2 uv = (vUv - 0.5)*5.;
	uv.x = fract(uv.x * 2.) - 0.5;

    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0, 0.0, 0.0);;
	finalColor *= 0.2;
    
    for (float i = 0.0; i < 8.0; i++) {
        uv = fract(uv * 1.5) - 0.5;

        float d = length(uv*uv) * exp(-length(uv0));

        vec3 col = palette(length(uv0) + i*.6 - time*1.6*0.1);

        d = sin(d*16. - time*0.1)/8.;
        d = abs(d);

        d = pow(0.01 / d, 1.2)/6.;

        finalColor += col * d;
    }
    
    gl_FragColor = vec4(mix(initialColor, finalColor, glitchiness), 1.0);
}