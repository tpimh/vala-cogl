class Box : Clutter.Actor {
    public Cogl.Color color = Cogl.Color.from_4f(0.0f, 0.0f, 0.0f, 1.0f);
    public float px = 300;
    public float py = 200;
    public float pz = -100;
    public float sx = 250;
    public float sy = 250;
    public float sz = 250;
    public float rx = 45.0f;
    public float ry = 45.0f;

    public override void paint() {
        Cogl.push_matrix();
        Cogl.translate(px, py, pz);
        Cogl.rotate(rx, 1, 0, 0);
        Cogl.rotate(ry, 0, 1, 0);
        Cogl.set_depth_test_enabled(true);

        Cogl.TextureVertex front[4];
        Cogl.TextureVertex back[4];
        Cogl.TextureVertex left[4];
        Cogl.TextureVertex right[4];
        Cogl.TextureVertex top[4];
        Cogl.TextureVertex bottom[4];

        Cogl.Color front_color = color;
        front_color.set_red_float((float)(Math.cos(ry / 180.0f * Math.PI) * Math.cos(rx / 180.0f * Math.PI)));
        Cogl.Color back_color = color;
        back_color.set_red_float((float)(-Math.cos(ry / 180.0f * Math.PI) * Math.cos(rx / 180.0f * Math.PI)));
        Cogl.Color left_color = color;
        left_color.set_red_float((float)(Math.sin(ry / 180.0f * Math.PI) * Math.cos(rx / 180.0f * Math.PI)));
        Cogl.Color right_color = color;
        right_color.set_red_float((float)(-Math.sin(ry / 180.0f * Math.PI) * Math.cos(rx / 180.0f * Math.PI)));
        Cogl.Color top_color = color;
        top_color.set_red_float((float)(-Math.sin(rx / 180.0f * Math.PI)));
        Cogl.Color bottom_color = color;
        bottom_color.set_red_float((float)(Math.sin(rx / 180.0f * Math.PI)));

        front[0].x = -sx / 2;
        front[0].y = -sy / 2;
        front[0].z = sz / 2;
        front[0].color = front_color;

        front[1].x = sx / 2;
        front[1].y = -sy / 2;
        front[1].z = sz / 2;
        front[1].color = front_color;

        front[2].x = sx / 2;
        front[2].y = sy / 2;
        front[2].z = sz / 2;
        front[2].color= front_color;

        front[3].x = -sx / 2;
        front[3].y = sy / 2;
        front[3].z = sz / 2;
        front[3].color= front_color;

        Cogl.polygon(front, true);

        back[0].x = -sx / 2;
        back[0].y = -sy / 2;
        back[0].z = -sz / 2;
        back[0].color = back_color;

        back[1].x = sx / 2;
        back[1].y = -sy / 2;
        back[1].z = -sz / 2;
        back[1].color = back_color;

        back[2].x = sx / 2;
        back[2].y = sy / 2;
        back[2].z = -sz / 2;
        back[2].color = back_color;

        back[3].x = -sx / 2;
        back[3].y = sy / 2;
        back[3].z = -sz / 2;
        back[3].color = back_color;

        Cogl.polygon(back, true);

        left[0].x = -sx / 2;
        left[0].y = -sy / 2;
        left[0].z = sz / 2;
        left[0].color = left_color;

        left[1].x = -sx / 2;
        left[1].y = -sy / 2;
        left[1].z = -sz / 2;
        left[1].color = left_color;

        left[2].x = -sx / 2;
        left[2].y = sy / 2;
        left[2].z = -sz / 2;
        left[2].color = left_color;

        left[3].x = -sx / 2;
        left[3].y = sy / 2;
        left[3].z = sz / 2;
        left[3].color = left_color;

        Cogl.polygon(left, true);

        right[0].x = sx / 2;
        right[0].y = -sy / 2;
        right[0].z = sz / 2;
        right[0].color = right_color;

        right[1].x = sx / 2;
        right[1].y = -sy / 2;
        right[1].z = -sz / 2;
        right[1].color = right_color;

        right[2].x = sx / 2;
        right[2].y = sy / 2;
        right[2].z = -sz / 2;
        right[2].color = right_color;

        right[3].x = sx / 2;
        right[3].y = sy / 2;
        right[3].z = sz / 2;
        right[3].color = right_color;

        Cogl.polygon(right, true);

        top[0].x = -sx / 2;
        top[0].y = -sy / 2;
        top[0].z = sz / 2;
        top[0].color = top_color;

        top[1].x = -sx / 2;
        top[1].y = -sy / 2;
        top[1].z = -sz / 2;
        top[1].color = top_color;

        top[2].x = sx / 2;
        top[2].y = -sy / 2;
        top[2].z = -sz / 2;
        top[2].color = top_color;

        top[3].x = sx / 2;
        top[3].y = -sy / 2;
        top[3].z = sz / 2;
        top[3].color = top_color;

        Cogl.polygon(top, true);

        bottom[0].x = -sx / 2;
        bottom[0].y = sy / 2;
        bottom[0].z = sz / 2;
        bottom[0].color = bottom_color;

        bottom[1].x = -sx / 2;
        bottom[1].y = sy / 2;
        bottom[1].z = -sz / 2;
        bottom[1].color = bottom_color;

        bottom[2].x = sx / 2;
        bottom[2].y = sy / 2;
        bottom[2].z = -sz / 2;
        bottom[2].color = bottom_color;

        bottom[3].x = sx / 2;
        bottom[3].y = sy / 2;
        bottom[3].z = sz / 2;
        bottom[3].color = bottom_color;

        Cogl.polygon(bottom, true);

        Cogl.pop_matrix();
   }

    public static int main(string[] args) {
        Clutter.init(ref args);
        var stage = new Clutter.Stage();
        stage.background_color = Clutter.Color.from_string("#aed");
        stage.hide.connect(Clutter.main_quit);

        var box = new Box();
        stage.add_child(box);

        Timeout.add(20, () => {
            box.rx += 0.5f;
            box.ry += 1.0f;
            box.queue_redraw();
            return true;
        });

        stage.show();

        Clutter.main();

        return 0;
    }
}
