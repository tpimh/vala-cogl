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

    public static float scale_x;
    public static float scale_y;

    public static const VertexP2T2 picture_vertices[] = {
        { -1.0f, -1.0f, 0.0f, 1.0f },
        { 1.0f, -1.0f, 1.0f, 1.0f },
        { 1.0f, 1.0f, 1.0f, 0.0f },
        { -1.0f, 1.0f, 0.0f, 0.0f }
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

                    fb.push_matrix();
                    fb.clear(BufferBit.COLOR, background);
                    fb.scale(scale_x, scale_y, 0);
                    picture.draw(fb, pipeline);
                    fb.pop_matrix();
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
        } catch (Error e) {
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
        (fb as Onscreen).add_resize_callback((onscreen, width, height) => {
                stdout.printf("resize: %dx%d\n", width, height);
                scale_x = 256.0f / width;
                scale_y = 256.0f / height;
            }, null);

        loop = new MainLoop(null, true);
        loop.run();

        return 0;
    }
}
