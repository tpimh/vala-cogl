using Cogl;

class Hello {
    public static Context ctx;
    public static Framebuffer fb;
    public static Primitive triangle;
    public static Pipeline pipeline;

    public static uint redraw_idle;
    public static bool is_dirty;
    public static bool draw_ready;

    public static const VertexP2C4 triangle_vertices[] = {
        { 0, 0.7f, 0xff, 0x00, 0x00, 0xff },
        { -0.7f, -0.7f, 0x00, 0xff, 0x00, 0xff },
        { 0.7f, -0.7f, 0x00, 0x00, 0xff, 0xff }
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

                    fb.clear4f(BufferBit.COLOR, 0, 0, 0, 1);
                    triangle.draw(fb, pipeline);
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

        onscreen = new Onscreen(ctx, 640, 480);
        onscreen.show();
        fb = onscreen as Framebuffer;

        onscreen.set_resizable((Bool)true);

        triangle = new Primitive.p2c4(ctx, VerticesMode.TRIANGLES, triangle_vertices);
        pipeline = new Pipeline(ctx);

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
