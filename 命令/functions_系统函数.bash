functions 系统函数

# returns OK if $1 contains $2
strstr() {
  [ "${1#*$2*}" = "$1" ] && return 1
  return 0
}

