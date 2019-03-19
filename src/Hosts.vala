namespace Ghost {
    private const string HOSTS_FILE_PATH = "/etc/hosts";

    private const string NEW_LINE = "\n";

    public errordomain HostsError {
        HOSTS_FILE,
        INVALID_LINE
    }

    public class Hosts {
        public GLib.Array<Host> hosts;

        public Hosts () {
            this.hosts = new GLib.Array<Host> ();
        }

        public Host? get_host (int index) {
            if (index >= 0 && index < this.hosts.length) {
                return this.hosts.index (index);
            }

            return null;
        }

        public void add_host () {
            this.hosts.append_val (new Host ("", "", false));
        }

        public void read_file () throws HostsError {
            string contents = "";

            try {
                GLib.FileUtils.get_contents (HOSTS_FILE_PATH, out contents);
            } catch (Error error) {
                throw new HostsError.HOSTS_FILE (_("Unable to open %s: %s".printf (HOSTS_FILE_PATH, error.message)));
            }

            if (contents.length == 0) {
                return;
            }

            string[] lines = contents.split_set (NEW_LINE);
            this.hosts = new GLib.Array<Host> ();

            foreach (unowned string line in lines) {
                try {
                    Host host = new Host.from_string (line);

                    if (host.is_valid ()) {
                        this.hosts.append_val (host);
                    } else {
                        throw new HostsError.INVALID_LINE (_("Invalid line in hosts file: %s".printf (line)));
                    }
                } catch (Error error) {
                    GLib.debug (error.message);
                }
            }
        }

        public void remove_host (int index) {
            if (index >= 0 && index < this.hosts.length) {
                this.hosts.remove_index (index);
            }
        }

        public void write_file () throws HostsError {
            string contents = "";

            for (int index = 0; index < this.hosts.length ; index++) {
                Host host = this.hosts.index (index);

                contents += host.to_string () + NEW_LINE;
            }

            try {
                GLib.FileUtils.set_contents (HOSTS_FILE_PATH, contents);
            } catch (Error error) {
                throw new HostsError.HOSTS_FILE (_("Unable to write %s: %s".printf (HOSTS_FILE_PATH, error.message)));
            }
        }
    }
}

