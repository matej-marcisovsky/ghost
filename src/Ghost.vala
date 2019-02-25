public class Ghost : Gtk.Application {
    public Ghost () {
        Object (
            application_id: "com.github.matej-marcisovsky.ghost",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var main_window = new Gtk.ApplicationWindow (this);

        main_window.default_width = 640;
        main_window.default_height = 480;
        main_window.title = "Ghost";

        main_window.show_all ();
    }

    public static int main (string[] args) {
        var ghost = new Ghost ();

        return ghost.run (args);
    }
}