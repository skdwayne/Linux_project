set -e

    Every script you write should include set -e at the top. This tells bash that it should exit the script if any statement returns a non-true return value. The benefit of using -e is that it prevents errors snowballing into serious issues when they could have been caught earlier. Again, for readability you may want to use set -o errexit.

    你写的每个脚本都应该在文件开头加上set -e,这句语句告诉bash如果任何语句的执行结果不是true则应该退出。这样的好处是防止错误像滚雪球般变大导致一个致命的错误，而这些错误本应该在之前就被处理掉。如果要增加可读性，可以使用set -o errexit，它的作用与set -e相同。


    Using -e gives you error checking for free. If you forget to check something, bash will do it for you. Unfortunately it means you can't check $? as bash will never get to the checking code if it isn't zero. There are other constructs you could use:

    使用-e帮助你检查错误。如果你忘记检查（执行语句的结果），bash会帮你执行。不幸的是，你将无法检查$?，因为如果执行的语句不是返回0，bash将无法执行到检查的代码。你可以使用其他的结构：

    command  
    if [ "$?"-ne 0]; then   
        echo "command failed";   
        exit 1;   
    fi   

>could be replaced with
能够被代替为

    [plain] view plain copy

    command || { echo "command failed"; exit 1; }   

>or

    [plain] view plain copy

    if ! command; then  
         echo "command failed";   
        exit 1;   
    fi   

>What if you have a command that returns non-zero or you are not interested in its return value? You can use command || true, or if you have a longer section of code, you can turn off the error checking, but I recommend you use this sparingly.
如果你有一个命令返回非0或者你对语句执行的结果不关心，那你可以使用command || true，或者你有一段很长的代码，你可以关闭错误检查（不使用set -e），但是我还是建议你保守地使用这个语句。
