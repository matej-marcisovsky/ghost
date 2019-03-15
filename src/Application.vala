namespace Ghost { 
    // COUNT must be last!
    private enum Columns {
        ACTIVE,
        IP_ADDRESS,
        HOSTNAME,
        COUNT
    }

    public class Application : Gtk.Application {
        public Hosts hosts { get; private set; }

        public Application () {
            Object (
                application_id: "com.github.matej-marcisovsky.ghost",
                flags: ApplicationFlags.FLAGS_NONE
            );

            this.hosts = new Hosts ();
            try {
                this.hosts.read_file ();
            } catch (HostsError error) {
                GLib.error (error.message);
            }
        }

        protected override void activate () {
            Ghost.MainWindow main_window = new Ghost.MainWindow (this);

            main_window.show_all ();
        }

        public static int main (string[] args) {
            Application application = new Application ();

            return application.run (args);
        }
    }
}

