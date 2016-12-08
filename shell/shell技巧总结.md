shell技巧总结

### 判断字符串长度

1. wc -L
2. awk length

```
    [root@web01 ~]# awk '{print length($0)}' <<<$YJJ   ## $0可以省略
```

3. expr length $a 
4. 变量子串
5. functions内置函数，strstr


