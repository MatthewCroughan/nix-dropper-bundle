# nix-dropper-bundle

nix-dropper-bundle is a collection of bundlers for dropping software onto
systems in unconventional ways.

## Examples

### memfd_create

To create a perl memfd_create bundle that will run on any machine that has perl, you
can follow the example below, replacing `hello` with a program you want to use:

1. Create the `memfd_create` bundle

   ```
   nix bundle --bundler github:matthewcroughan/nix-dropper-bundle#memfd_create github:nixos/nixpkgs#hello
   ```
2. See that it has made a result in the current directory

   ```
   user: matthew ~
   ❯ ls -lah ./hello-2.12.1-memfd_create-dropper
   lrwxrwxrwx 1 matthew users 72 Aug  8 04:44 ./hello-2.12.1-memfd_create-dropper -> /nix/store/46l1707bxmm13ixvpfmz9z8r7w5v5mxi-hello-2.12.1-memfd_create-dropper
   ```
3. Run it with `perl`

   ```
   user: matthew ~
   ❯ perl ./hello-2.12.1-memfd_create-dropper
   Hello, world!
   ```

memfd_create is a system call that allows us to create an anonymous file and
return a file descriptor that refers to it. We call it via `perl`, and use it to
map a binary into memory, then execute it. Since `perl` is usually available on
any system, we can use it as a way of executing an elf binary directly, without
needing to store a binary file on the filesystem and mark it as executable.

You can use this on any machine by piping it into perl, by any method. Imagine
serving it via a webserver, and being able to run `curl
https://server/my-dropper.pl`. This will run anywhere there is a perl
interpreter, without the need to store files on disk, or set the executable bit
on a file with `chmod +x`

**Note:** this method requires statically compiling the requested derivation.
This means a lot of software will fail to build when bundling, since some
software will not statically link for complex reasons. Bundling with
memfd_create may therefore not be possible for some software.

#### References
- https://man7.org/linux/man-pages/man2/memfd_create.2.html
- https://stackoverflow.com/questions/63208333/using-memfd-create-and-fexecve-to-run-elf-from-memory
- https://magisterquis.github.io/2018/03/31/in-memory-only-elf-execution.html
- https://unix.stackexchange.com/questions/22253/is-there-a-way-to-execute-a-native-binary-from-a-pipe
