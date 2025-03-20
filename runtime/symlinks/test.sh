#!/bin/sh

set -e

if [[ "$MSYSTEM" != "MSYS" ]]; then
    echo "skipped not on $MSYSTEM"
    exit 0;
fi

./make-menagerie.sh
MSYS=winsymlinks:deepcopy ln -s menagerie deepcopy
diff <(ls -lgG --time-style=+ -a menagerie/) <(ls -lgG --time-style=+ -a deepcopy/)
diff <(cmd //c "dir /a menagerie" | head -n-2 | tail -n+6 | cut -c25-) <(cmd //c "dir /a deepcopy" | head -n-2 | tail -n+6 | cut -c25-)
diff <(ls -lgG --time-style=+ -a menagerie/ | sed -e '1d;s|\( -> /\).*\(/.*\)$|\1...\2|;T;s|    \?[0-9]\+  |    0  |') - <<'EOF'
drwxr-xr-x 1    0  .
drwxr-xr-x 1    0  ..
brw-rw-rw- 1 8, 0  block
lrwxrwxrwx 1    5  blockdeepcopy -> block
lrwxrwxrwx 1    5  blocklnk -> block
lrwxrwxrwx 1    5  blocknativestrict -> block
lrwxrwxrwx 1    5  blocksys -> block
crw-rw-rw- 1 1, 3  char
lrwxrwxrwx 1    4  chardeepcopy -> char
lrwxrwxrwx 1    4  charlnk -> char
lrwxrwxrwx 1    4  charnativestrict -> char
lrwxrwxrwx 1    4  charsys -> char
drwxr-xr-x 1    0  dir
drwxr-xr-x 1    0  dirdeepcopy
lrwxrwxrwx 1    0  dirjunction -> /.../dir
lrwxrwxrwx 1    0  dirjunctiondeepcopy -> /.../dir
lrwxrwxrwx 1   11  dirjunctionlnk -> dirjunction
lrwxrwxrwx 1   11  dirjunctionnativestrict -> dirjunction
lrwxrwxrwx 1   11  dirjunctionsys -> dirjunction
lrwxrwxrwx 1    3  dirlnk -> dir
lrwxrwxrwx 1    3  dirnativestrict -> dir
lrwxrwxrwx 1    3  dirsys -> dir
prw-rw-rw- 1    0  fifo
lrwxrwxrwx 1    4  fifodeepcopy -> fifo
lrwxrwxrwx 1    4  fifolnk -> fifo
lrwxrwxrwx 1    4  fifonativestrict -> fifo
lrwxrwxrwx 1    4  fifosys -> fifo
-rw-r--r-- 1   23  file
-rw-r--r-- 1   23  filedeepcopy
lrwxrwxrwx 1    4  filelnk -> file
lrwxrwxrwx 1    4  filenativestrict -> file
lrwxrwxrwx 1    4  filesys -> file
srw-r--r-- 1    0  socket
lrwxrwxrwx 1    6  socketdeepcopy -> socket
lrwxrwxrwx 1    6  socketlnk -> socket
lrwxrwxrwx 1    6  socketnativestrict -> socket
lrwxrwxrwx 1    6  socketsys -> socket
EOF
diff <(cmd //c "dir /a menagerie" | head -n-2 | tail -n+6 | cut -c25- | sed -e 's|\[[A-Z]:\\.*\(\\.*\)\]$|[X:\\...\1]|;s/\([0-9]\{1,3\},\)\?[0-9]\{3\}\( .*lnk\.lnk\)$/0\2/;s/^ *//') - <<'EOF'
<DIR>          .
<DIR>          ..
126 block.lnk
24 blockdeepcopy
0 blocklnk.lnk
<JUNCTION>     blocknativestrict [...]
24 blocksys
126 char.lnk
22 chardeepcopy
0 charlnk.lnk
<JUNCTION>     charnativestrict [...]
22 charsys
<DIR>          dir
<DIR>          dirdeepcopy
<JUNCTION>     dirjunction [X:\...\dir]
<JUNCTION>     dirjunctiondeepcopy [X:\...\dir]
0 dirjunctionlnk.lnk
<SYMLINK>      dirjunctionnativestrict [dirjunction]
36 dirjunctionsys
0 dirlnk.lnk
<SYMLINKD>     dirnativestrict [dir]
20 dirsys
130 fifo.lnk
22 fifodeepcopy
0 fifolnk.lnk
<JUNCTION>     fifonativestrict [...]
22 fifosys
23 file
23 filedeepcopy
0 filelnk.lnk
<SYMLINK>      filenativestrict [file]
22 filesys
54 socket
26 socketdeepcopy
0 socketlnk.lnk
<JUNCTION>     socketnativestrict [...]
26 socketsys
EOF
