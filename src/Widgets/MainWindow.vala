namespace Ghost.Widgets {
    public class MainWindow : Gtk.ApplicationWindow {
        private int selected_index = 0;

        public Gtk.ListStore list_store { get; construct; }

        public weak Ghost.Application app { get; construct; }

        public MainWindow(Ghost.Application application) {
            Object (
                app: application,
                application: application,
                list_store: new Gtk.ListStore (Columns.COUNT, typeof(bool), typeof(string), typeof(string))
            );

            default_width = 640;
            default_height = 480;
        }

        construct {
            this.refill_list_store ();

            Gtk.Grid grid = new Gtk.Grid ();
            grid.orientation = Gtk.Orientation.VERTICAL;

            grid.add (this.get_scrolled_tree_view ());

            Ghost.Widgets.HeaderBar header_bar = new Ghost.Widgets.HeaderBar ();
            header_bar.add_host.connect (() => this.add_host ());
            header_bar.remove_host.connect (() => this.remove_host (this.selected_index));

            set_titlebar (header_bar);
            add (grid);
        }

        public signal void add_host ();

        public signal void active (int index, bool active);

        public signal void hostname (int index, string new_hostname);

        public signal void ip_address (int index, string new_ip_address);

        public signal void remove_host (int index);

        public void refill_list_store () {
            this.list_store.clear ();
            Gtk.TreeIter tree_iter = Gtk.TreeIter ();

            for (int index = 0; index < this.app.hosts.hosts.length ; index++) {
                Host host = this.app.hosts.hosts.index (index);

                this.list_store.append(out tree_iter);
                this.list_store.set(tree_iter,
                    Columns.ACTIVE, host.active,
                    Columns.IP_ADDRESS, host.ip_address,
                    Columns.HOSTNAME, host.hostname
                );
            }
        }

        private Gtk.CellRendererToggle get_cell_active () {
            Gtk.CellRendererToggle cell = new Gtk.CellRendererToggle ();

            cell.activatable = true;
            cell.toggled.connect ((toggle, path) => {
                this.active (int.parse (path), !toggle.active);
            });

            return cell;
        }

        private Gtk.CellRendererText get_cell_hostname () {
            Gtk.CellRendererText cell = new Gtk.CellRendererText ();

            cell.editable = true;
            cell.edited.connect ((path, new_hostname) => {
                this.hostname (int.parse (path), new_hostname);
            });

            return cell;
        }

        private Gtk.CellRendererText get_cell_ip_address () {
            Gtk.CellRendererText cell = new Gtk.CellRendererText ();

            cell.editable = true;
            cell.edited.connect ((path, new_ip_address) => {
                this.ip_address (int.parse (path), new_ip_address);
            });

            return cell;
        }

        private Gtk.ScrolledWindow get_scrolled_tree_view () {
            Gtk.TreeView tree_view = new Gtk.TreeView.with_model (this.list_store);
            tree_view.enable_search = true;
            tree_view.headers_clickable = true;
            tree_view.rubber_banding = true;
            tree_view.search_column = Columns.HOSTNAME;
            tree_view.set_hexpand (true);
            tree_view.set_vexpand (true);

            Gtk.TreeSelection tree_selection = tree_view.get_selection ();
            tree_selection.mode = Gtk.SelectionMode.BROWSE;
            tree_selection.changed.connect (selection => {
                Gtk.TreeModel model;
                Gtk.TreeIter iter;

                if (selection.get_selected (out model, out iter)) {
                    Gtk.TreePath path = model.get_path (iter);

                    if (path != null) {
                        this.selected_index = int.parse (path.to_string ());
                    }
                }
            });

            tree_view.insert_column_with_attributes (-1, _("Active"), this.get_cell_active (), "active", Columns.ACTIVE);
            tree_view.insert_column_with_attributes (-1, _("IP Address"), this.get_cell_ip_address (), "text", Columns.IP_ADDRESS);
            tree_view.insert_column_with_attributes (-1, _("Hostname"), this.get_cell_hostname (), "text", Columns.HOSTNAME);

            Gtk.ScrolledWindow scrolled_window = new Gtk.ScrolledWindow (null, null);
            scrolled_window.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            scrolled_window.add (tree_view);

            return scrolled_window;
        }
    }
}
