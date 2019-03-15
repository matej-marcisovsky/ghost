# project name and programming language
project('com.github.matej-marcisovsky.ghost', 'vala', 'c')

# Include the translations module
i18n = import('i18n')

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    meson.project_name(),
    [
        'src/Application-pkexec.vala'
    ],
    dependencies: [
        dependency('gtk+-3.0')
    ],
    install: true
)
executable(
    meson.project_name() + '.app',
    [
        'src/Application.vala',
        'src/MainWindow.vala',
        'src/Host.vala',
        'src/Hosts.vala'
    ],
    dependencies: [
        dependency('gtk+-3.0')
    ],
    install: true
)

#Translate and install our .desktop file
i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.desktop.in'),
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

#Translate and install our .appdata file
i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.appdata.xml.in'),
    output: meson.project_name() + '.appdata.xml',
    po_dir: join_paths(meson.source_root(), 'po'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

#Translate and install our .appdata file
i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.pkexec.policy.in'),
    output: meson.project_name() + '.pkexec.policy',
    po_dir: join_paths(meson.source_root(), 'po'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'polkit-1/actions')
)

subdir('po')
