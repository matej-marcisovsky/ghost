public static int main (string[] args) {
    string[] spawnArguments = {"pkexec", "/usr/bin/com.github.matej-marcisovsky.ghost.app"};
    string[] spawnEnvironment = Environ.get ();
    string spawnStdOut;
    string spawnStdError;
    int spawnExitStatus;

    try {
        Process.spawn_sync ("/", spawnArguments, spawnEnvironment, SpawnFlags.SEARCH_PATH, null, out spawnStdOut, out spawnStdError, out spawnExitStatus);

        stdout.printf ("Output: %s\n", spawnStdOut);
        stderr.printf ("There was an error in the spawned process: %s\n", spawnStdError);
        stderr.printf ("Exit status was: %d\n", spawnExitStatus);
    } catch (SpawnError spawnCaughtError) {
        stderr.printf ("There was an error spawining the process. Details: %s", spawnCaughtError.message);
    }

    return 0;
}

