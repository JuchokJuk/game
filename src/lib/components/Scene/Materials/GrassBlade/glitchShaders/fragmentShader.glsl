varying vec2 vUv;
uniform float time;
varying vec3 position_;

vec3 palette( float t ) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.163,0.116,0.157);

    return a + b*cos( 6.28318*(c*t+d) );
}

void main() {	
	vec2 uv = (position_.xz - 0.5) * 0.008;

    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0625, 0.25, 0.25);
	finalColor *= 0.2;
    
    for (float i = 0.0; i < 4.0; i++) {
        uv = fract(uv * 1.5) - 0.5;

        float d = length(uv*uv) * exp(-length(uv0));

        vec3 col = palette(length(uv0) + i*.6 - time*1.6*0.1);

        d = sin(d*16. - time*0.1)/16.;
        d = abs(d);

        d = pow(0.1 / d, 0.5)/0.8;

        finalColor += col * d;
    }

    float clarity = ( -vUv.y * 0.25 ) + 0.5;
    finalColor *= clarity;
	gl_FragColor = vec4(finalColor*0.2, 1.);
    
    // gl_FragColor = vec4(finalColor, 1.0);
}