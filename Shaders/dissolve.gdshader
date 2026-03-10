shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_always, cull_back;

uniform sampler2D noise_texture;
instance uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform float edge_size : hint_range(0.0, 0.2) = 0.05;
uniform vec4 edge_color : source_color = vec4(1.0, 0.4, 0.0, 1.0);

void fragment() {
    float noise = texture(noise_texture, UV).r;

    if (noise < dissolve_amount) {
        discard;
    }

    float edge = smoothstep(dissolve_amount, dissolve_amount + edge_size, noise);

    vec3 color = mix(edge_color.rgb, vec3(0.0), edge);
    float alpha = (1.0 - edge) * edge_color.a;

    ALBEDO = color;
    ALPHA = alpha;
    EMISSION = color;
}