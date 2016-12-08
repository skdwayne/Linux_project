iconv -f gb2312 -t UTF-8 2.html -o 2.utf8.html

[root@web01 scripts]# iconv --help
Usage: iconv [OPTION...] [FILE...]
Convert encoding of given files from one encoding to another.

 Input/Output format specification:
  -f, --from-code=NAME       encoding of original text
  -t, --to-code=NAME         encoding for output

 Information:
  -l, --list                 list all known coded character sets

 Output control:
  -c                         omit invalid characters from output
  -o, --output=FILE          output file
  -s, --silent               suppress warnings
      --verbose              print progress information

  -?, --help                 Give this help list
      --usage                Give a short usage message
  -V, --version              Print program version

Mandatory or optional arguments to long options are also mandatory or optional
for any corresponding short options.

For bug reporting instructions, please see:
<http://www.gnu.org/software/libc/bugs.html>.
