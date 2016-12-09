
# seq

```bash
[root@web01 get_artTitlelist]# seq -s "+" 10
1+2+3+4+5+6+7+8+9+10
```

```bash
[root@web01 get_artTitlelist]# seq -f "stu%02g" 10
stu01
stu02
stu03
stu04
stu05
stu06
stu07
stu08
stu09
stu10
```
## seq --help

```bash
[root@web01 get_artTitlelist]# seq --help
Usage: seq [OPTION]... LAST
  or:  seq [OPTION]... FIRST LAST
  or:  seq [OPTION]... FIRST INCREMENT LAST
Print numbers from FIRST to LAST, in steps of INCREMENT.

  -f, --format=FORMAT      use printf style floating-point FORMAT
  -s, --separator=STRING   use STRING to separate numbers (default: \n)
  -w, --equal-width        equalize width by padding with leading zeroes
      --help     display this help and exit
      --version  output version information and exit

If FIRST or INCREMENT is omitted, it defaults to 1.  That is, an
omitted INCREMENT defaults to 1 even when LAST is smaller than FIRST.
FIRST, INCREMENT, and LAST are interpreted as floating point values.
INCREMENT is usually positive if FIRST is smaller than LAST, and
INCREMENT is usually negative if FIRST is greater than LAST.
FORMAT must be suitable for printing one argument of type `double';
it defaults to %.PRECf if FIRST, INCREMENT, and LAST are all fixed point
decimal numbers with maximum precision PREC, and to %g otherwise.

Report seq bugs to bug-coreutils@gnu.org
GNU coreutils home page: <http://www.gnu.org/software/coreutils/>
General help using GNU software: <http://www.gnu.org/gethelp/>
For complete documentation, run: info coreutils 'seq invocation'
```