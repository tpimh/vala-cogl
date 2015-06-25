class Rectangle : Clutter.Actor {
    public Cogl.Color color = Cogl.Color.from_4f(0.68f, 0.1f, 0.1f, 1.0f);
    public float px = 300;
    public float py = 200;
    public float sx = 100;
    public float sy = 200;
    private float _r = 0.0f;

    public float r {
        get { return _r; }
        set {
            while (value > 360)
                value -= 360;
            while (value < 0)
                value += 360;
            _r = value;
            this.queue_redraw();
        }
    }

    public override void paint() {
        Cogl.push_matrix();
        Cogl.translate(px, py, 0);
        Cogl.rotate(r, 0, 0, 1);
        Cogl.set_source_color(color);

        Cogl.rectangle(-sx / 2, -sy / 2, sx / 2, sy / 2);

        Cogl.pop_matrix();
   }

    public static int main(string[] args) {
        Clutter.init(ref args);
        var stage = new Clutter.Stage();
        stage.background_color = Clutter.Color.from_string("#aed");
        stage.hide.connect(Clutter.main_quit);

        var rect = new Rectangle();
        stage.add_child(rect);
        stage.show();

        var transition = new Clutter.PropertyTransition("r");
        transition.animatable = rect;
        transition.duration = 2000;
        transition.repeat_count = -1;
        transition.set_from_value(0.0f);
        transition.set_to_value(180.0f);
        rect.add_transition("rotate", transition);

        Clutter.main();

        return 0;
    }
}
