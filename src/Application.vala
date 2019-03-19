namespace Ghost {
    // COUNT must be last!
    private enum Columns {
        ACTIVE,
        IP_ADDRESS,
        HOSTNAME,
        COUNT
    }

    public class Application : Gtk.Application {
        public Hosts hosts { get; construct; }

        private Ghost.Widgets.MainWindow main_window;

        public Application () {
            Object (
                application_id: "com.github.matej-marcisovsky.ghost",
                flags: ApplicationFlags.FLAGS_NONE,
                hosts: new Hosts ()
            );
        }

        construct {
            this.read_hosts ();
        }

        protected override void activate () {
            this.main_window = new Ghost.Widgets.MainWindow (this);

            this.main_window.active.connect (on_active);
            this.main_window.add_host.connect (on_add_host);
            this.main_window.hostname.connect (on_hostname);
            this.main_window.ip_address.connect (on_ip_address);
            this.main_window.remove_host.connect (on_remove_host);

            this.main_window.show_all ();
        }

        public static int main (string[] args) {
            Application application = new Application ();

            return application.run (args);
        }

        private void apply_changes () {
            //  this.write_hosts ();
            //  this.read_hosts ();
            this.main_window.refill_list_store ();
        }

        private void on_active (int index, bool active) {
            Host host = this.hosts.get_host (index);

            if (host == null) {
                GLib.warning ("Host not found at index %d".printf (index));
            } else {
                host.active = active;
                this.apply_changes ();
            }
        }

        private void on_add_host () {
            this.hosts.add_host ();
            this.main_window.refill_list_store ();
        }

        private void on_ip_address (int index, string new_ip_address) {
            Host host = this.hosts.get_host (index);

            if (host == null) {
                GLib.warning ("Host not found at index %d".printf (index));
            } else {
                host.ip_address = new_ip_address;
                this.apply_changes ();
            }
        }

        private void on_hostname (int index, string new_hostname) {
            Host host = this.hosts.get_host (index);

            if (host == null) {
                GLib.warning ("Host not found at index %d".printf (index));
            } else {
                host.hostname = new_hostname;
                this.apply_changes ();
            }
        }

        private void on_remove_host (int index) {
            this.hosts.remove_host (index);
            this.main_window.refill_list_store ();
        }

        private void read_hosts () {
            try {
                this.hosts.read_file ();
            } catch (HostsError error) {
                GLib.error (error.message);
            }
        }

        private void write_hosts () {
            try {
                this.hosts.write_file ();
            } catch (HostsError error) {
                GLib.error (error.message);
            }
        }
    }
}

