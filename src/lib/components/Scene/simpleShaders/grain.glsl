float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void mainImage(const in vec4 inputColor, const in vec2 uv, out vec4 outputColor){
    float noise = rand(uv + time) * 0.05;
    outputColor = inputColor + vec4(noise, noise, noise, 1.);
}