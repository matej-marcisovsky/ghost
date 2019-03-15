namespace Ghost {
    public class MainWindow : Gtk.ApplicationWindow {
        public weak Ghost.Application app { get; construct; }

        public MainWindow(Ghost.Application application) {
            Object (
                app: application,
                application: application
            );

            this.default_width = 640;
            this.default_height = 480;
            this.title = "Ghost";

            Gtk.Grid grid = new Gtk.Grid ();
            grid.orientation = Gtk.Orientation.VERTICAL;

            Gtk.ListStore list_store = this.get_list_store ();

            Gtk.TreeView tree_view = new Gtk.TreeView.with_model (list_store);
            tree_view.enable_search = true;
            tree_view.headers_clickable = true;
            tree_view.rubber_banding = true;
            tree_view.search_column = Columns.HOSTNAME;
            tree_view.set_hexpand (true);
            tree_view.set_vexpand (true);

            tree_view.insert_column_with_attributes (-1, _("Active"), this.get_cell_active (list_store), "active", Columns.ACTIVE);
            tree_view.insert_column_with_attributes (-1, _("IP Address"), this.get_cell_ip_address (), "text", Columns.IP_ADDRESS);
            tree_view.insert_column_with_attributes (-1, _("Hostname"), this.get_cell_hostname (), "text", Columns.HOSTNAME);

            grid.add (tree_view);

            this.add (grid);
        }

        private Gtk.CellRendererToggle get_cell_active (Gtk.ListStore list_store) {
            Gtk.CellRendererToggle cell = new Gtk.CellRendererToggle ();

            cell.toggled.connect ((toggle, path) => {
                Gtk.TreeIter tree_iter;
                GLib.Value ip;
                GLib.Value hostname;

                list_store.get_iter(out tree_iter, new Gtk.TreePath.from_string(path));
                list_store.get_value(tree_iter, Columns.IP_ADDRESS, out ip);
                list_store.get_value(tree_iter, Columns.HOSTNAME, out hostname);

                Host host = this.app.hosts.find_host (ip, hostname);
                if (host != null) {
                    bool active = !toggle.active;

                    host.active = active;
                    list_store.set(tree_iter, Columns.ACTIVE, active);
                } else {
                    GLib.error ("Host not found.");
                }
            });

            return cell;
        }

        private Gtk.CellRendererText get_cell_hostname () {
            Gtk.CellRendererText cell = new Gtk.CellRendererText ();

            cell.editable = true;
            // TODO connect
            return cell;
        }

        private Gtk.CellRendererText get_cell_ip_address () {
            Gtk.CellRendererText cell = new Gtk.CellRendererText ();

            cell.editable = true;
            // TODO connect
            return cell;
        }

        private Gtk.ListStore get_list_store () {
            Gtk.ListStore list_store = new Gtk.ListStore (Columns.COUNT, typeof(bool), typeof(string), typeof(string));

            Gtk.TreeIter tree_iter = Gtk.TreeIter ();

            foreach (Host host in this.app.hosts.hosts) {
                list_store.append(out tree_iter);
                list_store.set(tree_iter,
                    Columns.ACTIVE, host.active,
                    Columns.IP_ADDRESS, host.ip,
                    Columns.HOSTNAME, host.hostname
                );
            }

            return list_store;
        }
    }
}
