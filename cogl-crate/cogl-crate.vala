using Cogl;

class Crate {
    public static Framebuffer fb;
    public static int framebuffer_width;
    public static int framebuffer_height;

    public static Matrix view;

    public static Indices indices;
    public static Primitive prim;
    public static Texture texture;
    public static Pipeline crate_pipeline;

    public static Timer timer;

    /* A cube modelled using 4 vertices for each face.
     *
     * We use an index buffer when drawing the cube later so the GPU will
     * actually read each face as 2 separate triangles.
     */
    public static const VertexP3T2 vertices[] = {
        /* Front face */
        { /* pos = */ -1.0f, -1.0f,  1.0f, /* tex coords = */ 0.0f, 1.0f },
        { /* pos = */  1.0f, -1.0f,  1.0f, /* tex coords = */ 1.0f, 1.0f },
        { /* pos = */  1.0f,  1.0f,  1.0f, /* tex coords = */ 1.0f, 0.0f },
        { /* pos = */ -1.0f,  1.0f,  1.0f, /* tex coords = */ 0.0f, 0.0f },

        /* Back face */
        { /* pos = */ -1.0f, -1.0f, -1.0f, /* tex coords = */ 1.0f, 0.0f },
        { /* pos = */ -1.0f,  1.0f, -1.0f, /* tex coords = */ 1.0f, 1.0f },
        { /* pos = */  1.0f,  1.0f, -1.0f, /* tex coords = */ 0.0f, 1.0f },
        { /* pos = */  1.0f, -1.0f, -1.0f, /* tex coords = */ 0.0f, 0.0f },

        /* Top face */
        { /* pos = */ -1.0f,  1.0f, -1.0f, /* tex coords = */ 0.0f, 1.0f },
        { /* pos = */ -1.0f,  1.0f,  1.0f, /* tex coords = */ 0.0f, 0.0f },
        { /* pos = */  1.0f,  1.0f,  1.0f, /* tex coords = */ 1.0f, 0.0f },
        { /* pos = */  1.0f,  1.0f, -1.0f, /* tex coords = */ 1.0f, 1.0f },

        /* Bottom face */
        { /* pos = */ -1.0f, -1.0f, -1.0f, /* tex coords = */ 1.0f, 1.0f },
        { /* pos = */  1.0f, -1.0f, -1.0f, /* tex coords = */ 0.0f, 1.0f },
        { /* pos = */  1.0f, -1.0f,  1.0f, /* tex coords = */ 0.0f, 0.0f },
        { /* pos = */ -1.0f, -1.0f,  1.0f, /* tex coords = */ 1.0f, 0.0f },

        /* Right face */
        { /* pos = */  1.0f, -1.0f, -1.0f, /* tex coords = */ 1.0f, 0.0f },
        { /* pos = */  1.0f,  1.0f, -1.0f, /* tex coords = */ 1.0f, 1.0f },
        { /* pos = */  1.0f,  1.0f,  1.0f, /* tex coords = */ 0.0f, 1.0f },
        { /* pos = */  1.0f, -1.0f,  1.0f, /* tex coords = */ 0.0f, 0.0f },

        /* Left face */
        { /* pos = */ -1.0f, -1.0f, -1.0f, /* tex coords = */ 0.0f, 0.0f },
        { /* pos = */ -1.0f, -1.0f,  1.0f, /* tex coords = */ 1.0f, 0.0f },
        { /* pos = */ -1.0f,  1.0f,  1.0f, /* tex coords = */ 1.0f, 1.0f },
        { /* pos = */ -1.0f,  1.0f, -1.0f, /* tex coords = */ 0.0f, 1.0f }
    };

    public static void paint() {
        float rotation;

        fb.clear4f(BufferBit.COLOR | BufferBit.DEPTH, 0, 0, 0, 1);

        fb.push_matrix();
    
        fb.translate(framebuffer_width / 2, framebuffer_height / 2, 0);

        fb.scale(75, 75, 75);

        /* Update the rotation based on the time the application has been
         running so that we get a linear animation regardless of the frame
         rate */
        rotation = (float)timer.elapsed(null) * 60.0f;

        /* Rotate the cube separately around each axis.
         *
         * Note: Cogl matrix manipulation follows the same rules as for
         * OpenGL. We use column-major matrices and - if you consider the
         * transformations happening to the model - then they are combined
         * in reverse order which is why the rotation is done last, since
         * we want it to be a rotation around the origin, before it is
         * scaled and translated.
         */
        fb.rotate(rotation, 0, 0, 1);
        fb.rotate(rotation, 0, 1, 0);
        fb.rotate(rotation, 1, 0, 0);

        prim.draw(fb, crate_pipeline);

        fb.pop_matrix();
    }

    public static int main(string[] args) {
        Context ctx;
        Onscreen onscreen;
        float fovy, aspect, z_near, z_2d, z_far;
        DepthState depth_state;

        Source cogl_source;
        MainLoop loop;

        try {
            ctx = new Context(null);
        } catch (Error e) {
            stderr.printf("Failed to create context: %s\n", e.message);
            return 1;
        }

        onscreen = new Onscreen(ctx, 640, 480);
        fb = onscreen as Framebuffer;
        framebuffer_width = fb.get_width();
        framebuffer_height = fb.get_height();

        timer = new Timer();

        onscreen.show();

        fb.set_viewport(0, 0, framebuffer_width, framebuffer_height);

        fovy = 60;      /* y-axis field of view */
        aspect = (float)framebuffer_width / (float)framebuffer_height;
        z_near = 0.1f;  /* distance to near clipping plane */
        z_2d = 1000;    /* position to 2d plane */
        z_far = 2000;   /* distance to far clipping plane */

        fb.perspective(fovy, aspect, z_near, z_far);

        /* Since the pango renderer emits geometry in pixel/device coordinates
         * and the anti aliasing is implemented with the assumption that the
         * geometry *really* does end up pixel aligned, we setup a modelview
         * matrix so that for geometry in the plane z = 0 we exactly map x
         * coordinates in the range [0,stage_width] and y coordinates in the
         * range [0,stage_height] to the framebuffer extents with (0,0) being
         * the top left.
         *
         * This is roughly what Clutter does for a ClutterStage, but this
         * demonstrates how it is done manually using Cogl.
         */
        view = Matrix();
        view.init_identity();
        view.view_2d_in_perspective(fovy, aspect, z_near, z_2d, framebuffer_width, framebuffer_height);
        fb.set_modelview_matrix(view);

        /* rectangle indices allow the GPU to interpret a list of quads (the
         * faces of our cube) as a list of triangles.
         *
         * Since this is a very common thing to do
         * cogl_get_rectangle_indices() is a convenience function for
         * accessing internal index buffers that can be shared.
         */
        indices = get_rectangle_indices(ctx, 6 /* n_rectangles */);
        prim = new Primitive.p3t2(ctx, VerticesMode.TRIANGLES, vertices);
        /* Each face will have 6 indices so we have 6 * 6 indices in total... */
        prim.set_indices(indices, 6 * 6);

        /* Load a jpeg crate texture from a file */
        try {
            stdout.printf("crate.jpg (CC by-nc-nd http://bit.ly/9kP45T) ShadowRunner27 http://bit.ly/m1YXLh\n");
            texture = new Texture2D.from_file(ctx, "crate.jpg");
        } catch (Error e) {
            stderr.printf("Failed to load texture: %s\n", e.message);
            return 1;
        }

        /* a CoglPipeline conceptually describes all the state for vertex
         * processing, fragment processing and blending geometry. When
         * drawing the geometry for the crate this pipeline says to sample a
         * single texture during fragment processing... */
        crate_pipeline = new Pipeline(ctx);
        crate_pipeline.set_layer_texture(0, texture);

        /* Since the box is made of multiple triangles that will overlap
         * when drawn and we don't control the order they are drawn in, we
         * enable depth testing to make sure that triangles that shouldn't
         * be visible get culled by the GPU. */
        depth_state = DepthState();
        depth_state.init();
        depth_state.set_test_enabled((Bool)true);

        try {
            crate_pipeline.set_depth_state(depth_state);
        } catch (Error e) {
            stderr.printf("Failed to set depth state: %s\n", e.message);
            return 1;
        }

        cogl_source = glib_source_new(ctx, Priority.DEFAULT);
        cogl_source.attach(null);

        onscreen.add_frame_callback((onscreen, event, info) => {
                if (event == FrameEvent.SYNC) {
                    paint();
                    onscreen.swap_buffers();
                }
            }, null); /* destroy notify */
        onscreen.add_dirty_callback((onscreen, info) => {
                    paint();
                    onscreen.swap_buffers();
            }, null);

        loop = new MainLoop(null, true);
        loop.run();

        return 0;
    }
}
