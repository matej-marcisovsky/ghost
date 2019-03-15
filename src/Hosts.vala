namespace Ghost {
    private const string HOSTS_FILE_PATH = "/etc/hosts";

    public errordomain HostsError {
        HOSTS_FILE,
        INVALID_LINE
    }

    public class Hosts {
        public Host[] hosts;

        public Hosts () {
            this.hosts = new Host[0];
        }

        public Host? find_host (GLib.Value ip, GLib.Value hostname) {
            string _ip = (string) ip;
            string _hostname = (string) hostname;

            foreach (Host host in this.hosts) {
                if (host.ip == _ip && host.hostname == _hostname) {
                    return host;
                }
            }

            return null;
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

            string[] lines = contents.split_set ("\n");
            Host[] temp_hosts = new Host[0];

            foreach (unowned string line in lines) {
                try {
                    Host host = new Host.from_string (line);

                    if (host.is_valid ()) {
                        temp_hosts += host;
                    } else {
                        throw new HostsError.INVALID_LINE (_("Invalid line in hosts file: %s".printf (line)));
                    }
                } catch (Error error) {
                    GLib.debug (error.message);
                }
            }

            this.hosts = temp_hosts;
        }
    }
}

