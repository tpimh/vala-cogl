using Cogl;

static string get_winsys_name_for_id(WinsysID winsys_id) {
    switch (winsys_id) {
        case WinsysID.ANY:
            return "ERROR";
        case WinsysID.STUB:
            return "Stub";
        case WinsysID.GLX:
            return "GLX";
        case WinsysID.EGL_XLIB:
            return "EGL + Xlib platform";
        case WinsysID.EGL_NULL:
            return "EGL + NULL window system platform";
        case WinsysID.EGL_GDL:
            return "EGL + GDL platform";
        case WinsysID.EGL_WAYLAND:
            return "EGL + Wayland platform";
        case WinsysID.EGL_KMS:
            return "EGL + KMS platform";
        case WinsysID.EGL_ANDROID:
            return "EGL + Android platform";
        case WinsysID.WGL:
            return "EGL + Windows WGL platform";
        case WinsysID.SDL:
            return "EGL + SDL platform";
    }
  return "Unknown";
}

static void feature_cb(FeatureID feature) {
    string feature_name = "Unknown feature %d".printf(feature);
    switch (feature) {
        case FeatureID.TEXTURE_NPOT_BASIC:
            feature_name = "Non power of two textures (basic)";
            break;
        case FeatureID.TEXTURE_NPOT_MIPMAP:
            feature_name = "Non power of two textures (+ mipmap)";
            break;
        case FeatureID.TEXTURE_NPOT_REPEAT:
            feature_name = "Non power of two textures (+ repeat modes)";
            break;
        case FeatureID.TEXTURE_NPOT:
            feature_name = "Non power of two textures (fully featured)";
            break;
        case FeatureID.TEXTURE_RECTANGLE:
            feature_name = "Unnormalized coordinate, rectangle textures";
            break;
        case FeatureID.TEXTURE_3D:
            feature_name = "3D texture support";
            break;
        case FeatureID.OFFSCREEN:
            feature_name = "Offscreen rendering support";
            break;
        case FeatureID.OFFSCREEN_MULTISAMPLE:
            feature_name = "Offscreen rendering with multisampling support";
            break;
        case FeatureID.ONSCREEN_MULTIPLE:
            feature_name = "Multiple onscreen framebuffers supported";
            break;
        case FeatureID.GLSL:
            feature_name = "GLSL support";
            break;
        case FeatureID.UNSIGNED_INT_INDICES:
            feature_name = "Unsigned integer indices";
            break;
        case FeatureID.DEPTH_RANGE:
            feature_name = "cogl_pipeline_set_depth_range() support";
            break;
        case FeatureID.POINT_SPRITE:
            feature_name = "Point sprite coordinates";
            break;
        case FeatureID.MAP_BUFFER_FOR_READ:
            feature_name = "Mapping buffers for reading";
            break;
        case FeatureID.MAP_BUFFER_FOR_WRITE:
            feature_name = "Mapping buffers for writing";
            break;
        case FeatureID.MIRRORED_REPEAT:
            feature_name = "Mirrored repeat wrap modes";
            break;
        case FeatureID.GLES2_CONTEXT:
            feature_name = "GLES2 API integration supported";
            break;
        case FeatureID.DEPTH_TEXTURE:
            feature_name = "Depth Textures";
            break;
        case FeatureID.PER_VERTEX_POINT_SIZE:
            feature_name = "Per-vertex point size";
            break;
    }

    stdout.printf(" » %s\n", feature_name);
}

static void output_cb(Output output) {
    string order = "";
    float refresh;

    stdout.printf(" Output:\n");
    stdout.printf("  » position = (%d, %d)\n", output.get_x(), output.get_y());
    stdout.printf("  » resolution = %d x %d\n", output.get_width(), output.get_height());
    stdout.printf("  » physical size = %dmm x %dmm\n", output.get_mm_width(), output.get_mm_height());
    switch (output.get_subpixel_order()) {
        case SubpixelOrder.UNKNOWN:
            order = "unknown";
            break;
        case SubpixelOrder.NONE:
            order = "non-standard";
            break;
        case SubpixelOrder.HORIZONTAL_RGB:
            order = "horizontal,rgb";
            break;
        case SubpixelOrder.HORIZONTAL_BGR:
            order = "horizontal,bgr";
            break;
        case SubpixelOrder.VERTICAL_RGB:
            order = "vertical,rgb";
            break;
        case SubpixelOrder.VERTICAL_BGR:
            order = "vertical,bgr";
            break;
    }
    stdout.printf("  » sub pixel order = %s\n", order);

    refresh = output.get_refresh_rate();
    if (refresh != 0)
        stdout.printf("  » refresh = %f Hz\n", refresh);
    else
        stdout.printf("  » refresh = unknown\n");
}

int main(string[] args) {
    Renderer renderer;
    Display display;
    Context ctx;
    WinsysID winsys_id;
    string winsys_name;

    try {
        ctx = new Context(null);
    } catch (Error e) {
        stderr.printf("Failed to create context: %s\n", e.message);
        return 1;
    }

    display = ctx.get_display();
    renderer = display.get_renderer();
    winsys_id = renderer.get_winsys_id();
    winsys_name = get_winsys_name_for_id(winsys_id);
    stdout.printf("Renderer: %s\n\n", winsys_name);

    stdout.printf("Features:\n");
    foreach_feature(ctx, feature_cb);

    stdout.printf("Outputs:\n");
    renderer.foreach_output(output_cb);

    return 0;
}

