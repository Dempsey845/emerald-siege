shader_type spatial;
render_mode unshaded, cull_back, depth_draw_always, blend_add;

// Hit effect settings
uniform vec4 hit_color: source_color = vec4(1.0, 0.0, 0.0, 0.5);
uniform float pulse_speed : hint_range(0.0, 20.0) = 15.0;
uniform float duration : hint_range(0.0, 5.0) = 1.0;  // Duration of hit
uniform float amplitude : hint_range(0.0, 0.5) = 0.1; // Distortion strength

// INTERNALS
instance uniform float time_passed : hint_range(0.0, 5.0) = 1.0; // Controlled via script

void vertex() {
    float fade = clamp(1.0 - time_passed / duration, 0.0, 1.0);
    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;

    // Distort mesh along normals
    VERTEX += NORMAL * pulse * amplitude * fade;
}

void fragment() {
    float fade = clamp(1.0 - time_passed / duration, 0.0, 1.0);
    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;

    ALBEDO = hit_color.rgb * fade * pulse;
    ALPHA = hit_color.a * fade * pulse;
    EMISSION = hit_color.rgb * fade * pulse;
}