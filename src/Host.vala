const string COMMENT_CHAR = "#";

public errordomain HostError {
    INVALID_IP,
    INVALID_STRING
}

public class Host {
    private string _ip;

    public bool active { get; set; default = false; }

    public string ip {
        get {
            return this._ip;
        }
        set {
            if (!Host.is_valid_ip (value)) {
                throw new HostError.INVALID_IP("Invalid IP adress.");
            }

            this._ip = value;
        }
        default = "127.0.0.1";
    }

    public string hostname { get; set; default = "localhost"; }

    public static bool is_valid_ip (string ip) {
        /* Tests if hostname is the string form of an IPv4 or IPv6 address. */
        return GLib.Hostname.is_ip_address (ip);
    }

    public Host (string ip, string hostname, bool active = false) {
        this.ip = ip.strip ();
        this.hostname = hostname.strip ();
        this.active = active;
    }

    public Host.from_string (string text) {
        if (text.length == 0) {
            throw new HostError.INVALID_STRING("Source string is empty or in invalid format.");
        }

        string text_stripped = text.strip ();
        bool active = true;

        if (text_stripped.has_prefix (COMMENT_CHAR)) {
            active = false;
            text_stripped = text_stripped.slice (1, text_stripped.length);
            text_stripped = text_stripped.strip ();
        }

        string[] text_parts = text_stripped.split_set (" \t", 2);
        if (text_parts.length != 2) {
            throw new HostError.INVALID_STRING("Source string is empty or in invalid format.");
        }

        this(text_parts[0], text_parts[1], active);
    }

    public string to_string () {
        return (this.active ? "" : COMMENT_CHAR) + this.ip + " " + this.hostname;
    }
}
