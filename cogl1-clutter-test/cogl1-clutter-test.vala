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

        Cogl.TextureVertex vertex[4];

        vertex[0].x = -sx / 2;
        vertex[0].y = -sy / 2;
        vertex[0].color = color;

        vertex[1].x = sx / 2;
        vertex[1].y = -sy / 2;
        vertex[1].color = color;

        vertex[2].x = sx / 2;
        vertex[2].y = sy / 2;
        vertex[2].color= color;

        vertex[3].x = -sx / 2;
        vertex[3].y = sy / 2;
        vertex[3].color= color;

        Cogl.polygon(vertex, true);

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
