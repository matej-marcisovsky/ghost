namespace Ghost {
    // COUNT must be last!
    private enum Columns {
        ACTIVE,
        IP_ADDRESS,
        HOSTNAME,
        COUNT
    }

    private const string HOSTS_FILE_PATH = "/etc/hosts";

    public class Application : Gtk.Application {
        public Hosts hosts { get; construct; }

        private Ghost.Widgets.MainWindow main_window;

        public Application () {
            Object (
                application_id: "com.github.matej-marcisovsky.ghost",
                flags: ApplicationFlags.FLAGS_NONE,
                hosts: new Hosts (HOSTS_FILE_PATH)
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
            this.write_hosts ();
            this.read_hosts ();
            this.main_window.refill_list_store ();
        }

        private void on_active (int index, bool active) {
            Host host = this.hosts.get_host (index);

            if (host == null) {
                GLib.warning ("Host not found at index %d".printf (index));
            } else {
                try {
                    host.change_active (active);

                    this.apply_changes ();
                } catch (HostError error) {
                    this.show_warn_dialog (error);
                }
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
                try {
                    host.change_ip_address (new_ip_address);

                    this.apply_changes ();
                } catch (HostError error) {
                    this.show_warn_dialog (error);
                }
            }
        }

        private void on_hostname (int index, string new_hostname) {
            Host host = this.hosts.get_host (index);

            if (host == null) {
                GLib.warning ("Host not found at index %d".printf (index));
            } else {
                try {
                    host.change_hostname (new_hostname);

                    this.apply_changes ();
                } catch (HostError error) {
                    this.show_warn_dialog (error);
                }
            }
        }

        private void on_remove_host (int index) {
            this.hosts.remove_host (index);
            this.main_window.refill_list_store ();
        }

        private void show_error_dialog (Error error) {
            Granite.MessageDialog error_dialog = new Granite.MessageDialog.with_image_from_icon_name (
                    _("Something broke!"),
                    error.message,
                    "dialog-error",
                    Gtk.ButtonsType.CLOSE
                );

                error_dialog.set_transient_for (this.main_window);
                error_dialog.run ();
                error_dialog.destroy ();
        }

        private void show_warn_dialog (Error error) {
            Granite.MessageDialog warn_dialog = new Granite.MessageDialog.with_image_from_icon_name (
                    _("Whoops!"),
                    error.message,
                    "dialog-warning",
                    Gtk.ButtonsType.CLOSE
                );

                warn_dialog.set_transient_for (this.main_window);
                warn_dialog.run ();
                warn_dialog.destroy ();
        }

        private void read_hosts () {
            try {
                this.hosts.read_file ();
            } catch (HostsError error) {
                this.show_error_dialog (error);
            }
        }

        private void write_hosts () {
            try {
                this.hosts.write_file ();
            } catch (HostsError error) {
                this.show_error_dialog (error);
            }
        }
    }
}

