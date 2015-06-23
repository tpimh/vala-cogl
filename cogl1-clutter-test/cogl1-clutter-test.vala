class Rectangle : Clutter.Actor {
    public Cogl.Color color = Cogl.Color.from_4f(0.68f, 0.1f, 0.1f, 1.0f);
    public float px = 300;
    public float py = 200;
    public float sx = 100;
    public float sy = 200;
    public float rotation = 45.0f;

    public override void paint() {
        Cogl.push_matrix();
        Cogl.translate(px, py, 0);
        Cogl.rotate(rotation, 0, 0, 1);
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

        Clutter.main();

        return 0;
    }
}
