varying vec2 vUv;
uniform sampler2D grassTexture;

void main() {
    gl_FragColor = texture2D(grassTexture, vUv);
}