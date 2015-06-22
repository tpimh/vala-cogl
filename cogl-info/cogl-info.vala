using Cogl;

struct Feature {
    public FeatureID id;
    public string short_description;
    public string long_description;
}

class CoglInfo {
    private static int output_num = 0;

    public static const Feature[] features = {
        {
            FeatureID.TEXTURE_NPOT_BASIC,"Non power of two textures (basic)",
            "The hardware supports non power of two textures, but you also " +
            "need to check the FeatureID.TEXTURE_NPOT_MIPMAP and " +
            "FeatureID.TEXTURE_NPOT_REPEAT features to know if the " +
            "hardware supports npot texture mipmaps or repeat modes other " +
            "than COGL_RENDERER_PIPELINE_WRAP_MODE_CLAMP_TO_EDGE respectively."
        }, {
            FeatureID.TEXTURE_NPOT_MIPMAP,
            "Non power of two textures (+ mipmap)",
            "Mipmapping is supported in conjuntion with non power of two " +
            "textures."
        }, {
            FeatureID.TEXTURE_NPOT_REPEAT,
            "Non power of two textures (+ repeat modes)",
            "Repeat modes other than " +
            "COGL_RENDERER_PIPELINE_WRAP_MODE_CLAMP_TO_EDGE are supported by " +
            "the hardware in conjunction with non power of two textures."
        }, {
            FeatureID.TEXTURE_NPOT,
            "Non power of two textures (fully featured)",
            "Non power of two textures are supported by the hardware. This " +
            "is a equivalent to the FeatureID.TEXTURE_NPOT_BASIC, " +
            "FeatureID.TEXTURE_NPOT_MIPMAP and " +
            "FeatureID.TEXTURE_NPOT_REPEAT features combined."
        }, {
            FeatureID.TEXTURE_RECTANGLE,
            "Unnormalized coordinate, rectangle textures",
            "Support for rectangular textures with non-normalized texture " +
            "coordinates."
        }, {
            FeatureID.TEXTURE_3D,
            "3D texture support",
            "3D texture support"
        }, {
            FeatureID.OFFSCREEN,
            "Offscreen rendering support",
            "Offscreen rendering support"
        }, {
            FeatureID.OFFSCREEN_MULTISAMPLE,
            "Offscreen rendering with multisampling support",
            "Offscreen rendering with multisampling support"
        }, {
            FeatureID.ONSCREEN_MULTIPLE,
            "Multiple onscreen framebuffers supported",
            "Multiple onscreen framebuffers supported"
        }, {
            FeatureID.GLSL,
            "GLSL support",
            "GLSL support"
        }, {
            FeatureID.UNSIGNED_INT_INDICES,
            "Unsigned integer indices",
            "COGL_RENDERER_INDICES_TYPE_UNSIGNED_INT is supported in cogl_indices_new()."
        }, {
            FeatureID.DEPTH_RANGE,
            "cogl_pipeline_set_depth_range() support",
            "cogl_pipeline_set_depth_range() support"
        }, {
            FeatureID.POINT_SPRITE,
            "Point sprite coordinates",
            "cogl_pipeline_set_layer_point_sprite_coords_enabled() is supported"
        }, {
            FeatureID.MAP_BUFFER_FOR_READ,
            "Mapping buffers for reading",
            "Mapping buffers for reading"
        }, {
            FeatureID.MAP_BUFFER_FOR_WRITE,
            "Mapping buffers for writing",
            "Mapping buffers for writing"
        }, {
            FeatureID.MIRRORED_REPEAT,
            "Mirrored repeat wrap modes",
            "Mirrored repeat wrap modes"
        }, {
            FeatureID.GLES2_CONTEXT,
            "GLES2 API integration supported",
            "Support for creating a GLES2 context for using the GLES2 API in a " +
            "way that's integrated with Cogl."
        }, {
            FeatureID.DEPTH_TEXTURE,
            "Depth Textures",
            "CoglFramebuffers can be configured to render their depth buffer into " +
            "a texture"
        }, {
            FeatureID.PER_VERTEX_POINT_SIZE,
            "Per-vertex point size",
            "cogl_point_size_in can be used as an attribute to specify a per-vertex " +
            "point size"
        }
    };

    public static string get_winsys_name_for_id(WinsysID winsys_id) {
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

    public static void feature_cb(FeatureID feature) {
        foreach (Feature f in features) {
            if (f.id == feature) {
                    stdout.printf(" » %s\n", f.short_description);
                    return;
            }
        }

        stdout.printf(" » Unknown feature %d\n", feature);
    }

    public static void output_cb(Output output) {
        string order = "";
        float refresh;

        stdout.printf(" Output%d:\n", output_num++);
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

    public static int main(string[] args) {
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
        if (output_num == 0)
            stdout.printf(" Unknown\n");

        return 0;
    }
}
