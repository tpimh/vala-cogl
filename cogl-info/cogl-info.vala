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
    stdout.printf(" » Feature #%d\n", feature);
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

