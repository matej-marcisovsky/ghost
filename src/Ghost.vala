// COUNT must be last!
private enum Columns {
    ACTIVE,
    IP_ADDRESS,
    HOSTNAME,
    COUNT
}

public class Ghost : Gtk.Application {
    private Hosts hosts;

    public Ghost () {
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
        Gtk.ApplicationWindow main_window = new Gtk.ApplicationWindow (this);

        main_window.default_width = 640;
        main_window.default_height = 480;
        main_window.title = "Ghost";

        Gtk.Grid grid = new Gtk.Grid ();
        grid.orientation = Gtk.Orientation.VERTICAL;

        Gtk.TreeView tree_view = new Gtk.TreeView.with_model (this.get_list_store ());
        tree_view.enable_search = true;
        tree_view.headers_clickable = true;
        tree_view.rubber_banding = true;
        tree_view.search_column = Columns.HOSTNAME;
        tree_view.set_hexpand (true);
        tree_view.set_vexpand (true);

        tree_view.insert_column_with_attributes (-1, _("Active"), this.get_cell_active (), "active", Columns.ACTIVE);
        tree_view.insert_column_with_attributes (-1, _("IP Address"), this.get_cell_ip_address (), "text", Columns.IP_ADDRESS);
        tree_view.insert_column_with_attributes (-1, _("Hostname"), this.get_cell_hostname (), "text", Columns.HOSTNAME);

        grid.add (tree_view);

        main_window.add (grid);
        main_window.show_all ();
    }

    public static int main (string[] args) {
        Ghost ghost = new Ghost ();

        return ghost.run (args);
    }

    private Gtk.CellRendererToggle get_cell_active () {
        Gtk.CellRendererToggle cell = new Gtk.CellRendererToggle ();
        // TODO connect
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

        foreach (Host host in this.hosts.hosts) {
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
