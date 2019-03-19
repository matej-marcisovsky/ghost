namespace Ghost.Widgets {
    public class HeaderBar : Gtk.HeaderBar {
        public HeaderBar () {
            Object (
                show_close_button: true,
                title: "Ghost"
            );
        }

        construct {
            Gtk.Button add_button = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
            add_button.clicked.connect (() => {
                this.add_host ();
            });

            Gtk.Button remove_button = new Gtk.Button.from_icon_name ("user-trash", Gtk.IconSize.LARGE_TOOLBAR);
            remove_button.clicked.connect (() => {
                this.remove_host ();
            });

            pack_start (add_button);
            pack_start (remove_button);
        }

        public signal void add_host ();

        public signal void remove_host ();
    }
}

