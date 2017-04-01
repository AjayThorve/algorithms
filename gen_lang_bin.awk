#!/usr/bin/awk -f

# This program generates the program dirs for the Algorithm Museum's languages.
# It reads langs.txt to get the language list, and stdin for the chapter names.

BEGIN {
    header = "CHAPTER"
    file = "langs.txt";
    while((getline < file ) > 0 ) {
    	langs[$1] = $2  # record each language and ext
    }
    for (lang in langs) {
      header = header " " lang " |"
    }
    print header
}

/^[0-9]/ {     # this is a chapter name
    k = $2
    for( lang in langs ) {
        dir = lang "/" $2
        cmd = "ls " dir "/*" langs[lang] " 2>/dev/null | egrep -v 'README' | awk 'END{print NR}'"
        cmd | getline x
        close(cmd)
        if (x == 0) {
          k = k " 0 "
        } else {
          k = k " 1 "
        }
    }
    print k
}
