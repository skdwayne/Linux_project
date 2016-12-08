vim 编辑器自动注释


        call append(line("."), "\##############################################")
        call append(line(".")+1, "\# File Name: ".expand("%"))
        call append(line(".")+2, "\# Author: yjj")
        call append(line(".")+3, "\# qq: 493535459")
        call append(line(".")+4, "\# Created Time: ".strftime("%c"))
        call append(line(".")+5, "\###########################################")

        