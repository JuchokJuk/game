vec2 barrelDistortion(vec2 coord, float amt) {
	vec2 cc = coord - 0.5;
	float dist = dot(cc, cc);
	return coord + cc * (dist*dist*dist)  * amt;
}

void mainImage(const in vec4 inputColor, const in vec2 uv, out vec4 outputColor) {

	outputColor.r  = texture(inputBuffer, barrelDistortion(uv, -8.)).r;
	outputColor.g  = texture(inputBuffer, barrelDistortion(uv, -1.)).g;
	outputColor.ba = texture(inputBuffer, barrelDistortion(uv, -8.)).ba;
}