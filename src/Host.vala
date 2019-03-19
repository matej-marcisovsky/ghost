namespace Ghost {
    private const string COMMENT_CHAR = "#";

    public errordomain HostError {
        IP_ADDRESS,
        SOURCE_STRING
    }

    public class Host {
        private bool _active;

        private string _ip_address = "";

        public bool active {
            get {
                return this._active && this.is_valid ();
            }

            set {
                this._active = value;
            }

            default = false;
        }

        public string ip_address {
            get {
                return this._ip_address;
            }

            set {
                if (Host.is_valid_ip_address (value)) {
                    this._ip_address = value;
                }
            }
        }

        public string hostname { get; set; }

        public static bool is_valid_ip_address (string ip_address) {
            /* Tests if hostname is the string form of an IPv4 or IPv6 address. */
            return GLib.Hostname.is_ip_address (ip_address);
        }

        public Host (string ip_address, string hostname, bool active = false) {
            this.ip_address = ip_address.strip ();
            this.hostname = hostname.strip ();
            this.active = active;
        }

        public Host.from_string (string text) throws HostError {
            if (text.length == 0) {
                throw new HostError.SOURCE_STRING(_("Source string is empty."));
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
                throw new HostError.SOURCE_STRING(_("Source string is invalid."));
            }

            this(text_parts[0], text_parts[1], active);
        }

        public bool is_valid () {
            if (
                this.ip_address != null &&
                this.ip_address.length > 0 &&
                this.hostname != null &&
                this.hostname.length > 0
            ) {
                return true;
            }

            return false;
        }

        public string to_string () {
            return (this.active ? "" : COMMENT_CHAR) + this.ip_address + " " + this.hostname;
        }
    }
}

