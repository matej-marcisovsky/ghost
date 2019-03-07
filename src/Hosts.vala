private const string HOSTS_FILE_PATH = "/etc/hosts";

public errordomain HostsError {
    HOSTS_FILE
}

public class Hosts {
    public Host[] hosts;

    public Hosts () {
        this.hosts = new Host[0];
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
                temp_hosts += new Host.from_string (line);
            } catch (Error error) {
                GLib.debug (error.message);
            }
        }

        this.hosts = temp_hosts;
    }
}
