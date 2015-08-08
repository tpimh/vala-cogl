using Cogl;

class Hello {
    public static Context ctx;
    public static Framebuffer fb;
    public static Color background;
    public static Texture texture;
    public static Primitive picture;
    public static Pipeline pipeline;

    public static uint redraw_idle;
    public static bool is_dirty;
    public static bool draw_ready;

    public static const VertexP2T2 picture_vertices[] = {
        { -0.5f, -0.5f, 0.0f, 1.0f },
        { 0.5f, -0.5f, 1.0f, 1.0f },
        { 0.5f, 0.5f, 1.0f, 0.0f },
        { -0.5f, 0.5f, 0.0f, 0.0f }
    };

    public static void maybe_redraw(){
        if (is_dirty && draw_ready && redraw_idle == 0) {
            /* We'll draw on idle instead of drawing immediately so that
             * if Cogl reports multiple dirty rectangles we won't
             * redundantly draw multiple frames */
            redraw_idle = Idle.add(() => {
                    redraw_idle = 0;
                    is_dirty = false;
                    draw_ready = false;

                    fb.clear(BufferBit.COLOR, background);
                    picture.draw(fb, pipeline);
                    (fb as Onscreen).swap_buffers();

                    return false;
                });
        }
    }

    public static int main(string[] args) {
        Onscreen onscreen;

        Source cogl_source;
        MainLoop loop;

        redraw_idle = 0;
        is_dirty = false;
        draw_ready = true;

        try {
            ctx = new Context(null);
        } catch (GLib.Error e) {
            stderr.printf("Failed to create context: %s\n", e.message);
            return 1;
        }

        onscreen = new Onscreen(ctx, 512, 512);
        onscreen.show();
        fb = onscreen as Framebuffer;

        onscreen.set_resizable((Bool)true);

        background = new Color();
        background.init_from_4f(0.4f, 0.6f, 0.9f, 0.0f);

        try {
            texture = new Texture2D.from_file(ctx, "tex256.png");
        } catch (Error e) {
            stderr.printf("Failed to load texture: %s\n", e.message);
            return 1;
        }

        picture = new Primitive.p2t2(ctx, VerticesMode.TRIANGLE_FAN, picture_vertices);
        pipeline = new Pipeline(ctx);
        pipeline.set_layer_texture(0, texture);

        cogl_source = glib_source_new(ctx, Priority.DEFAULT);
        cogl_source.attach(null);

        (fb as Onscreen).add_frame_callback((onscreen, event, info) => {
                if (event == FrameEvent.SYNC) {
                    draw_ready = true;
                    maybe_redraw();
                }
            }, null);
        (fb as Onscreen).add_dirty_callback((onscreen, info) => {
                is_dirty = true;
                maybe_redraw();
            }, null);

        loop = new MainLoop(null, true);
        loop.run();

        return 0;
    }
}
