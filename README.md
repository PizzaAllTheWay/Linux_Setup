# Custom Comands
Superior "ls -la" command:
```
$ lz
```
```
$ lz <DIR>
```

Superior version of "cat" command:
```
$ bat <FILE>
```

Alert comand
```
$ alert
```
```
$ sleep 5; alert "Helloooo"
```



<br>



# Good commands 
Task manager:
```
$ sudo apt install btop
$ btop
```

Disk usage analyzer:
```
$ curl -LSfs https://raw.githubusercontent.com/Byron/dua-cli/master/ci/install.sh | \
    sh -s -- --git Byron/dua-cli --target x86_64-unknown-linux-musl --crate dua
$ sudo mv ~/.cargo/bin/dua /usr/local/bin/
$ dua i
```

Graphical directory structure listing:
```
$ sudo apt install tree
$ tree
```

Search file contents:
```
$ sudo apt install ripgrep
$ rg "<SEARCH_TEXT>"
```

Find files by name:
```
$ sudo apt install fd-find
$ fdfind <FILENAME>
```

Terminal instance that persists even after disconnect:
```
$ sudo apt install tmux
$ tmux
```

Hacker man:
```
$ sudo apt install hollywood
$ hollywood
```
