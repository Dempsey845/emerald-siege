shader_type canvas_item;

uniform float intensity : hint_range(0, 1) = 0.5; // max opacity
uniform vec4 color : source_color = vec4(1.0, 0.4, 0.0, 1.0); // orange-red

void fragment() {
    vec2 uv = SCREEN_UV; // 0.0 at bottom-left, 1.0 at top-right
	vec2 center = vec2(0.5, 0.5); // screen centre
	float dist = distance(uv, center); // distance from centre (0.0 → ~0.7 at corners)
    float vignette = smoothstep(0.5, 0.7, dist); // tweak 0.5 & 0.7 for falloff
	COLOR = vec4(color.rgb, vignette * intensity);
}