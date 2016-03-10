---
layout: post
title:  "Linux命令之sed与awk"
date:   2016-03-06 11:55:00 ＋8000
categories: Linux
---
* 内容目录
{:toc}

> `sed`与`awk`是可以单独出书的两个Linux命令，它们的功能非常强大，本章节将分别介绍着两个命令。其中`sed`使用的是`gnu-sed 4.2.2`版本，对应下文中出现的`gsed`，而不是Mac自带的`sed`。`awk`同样使用`gnu`版本的`awk`，对应文中出现的`gawk`。

## 1. sed命令(Mac)

sed是Linux中的一个文件编辑工具，按行处理文件内容，可以实现插入，删除，替换等功能。更重要的是sed命令可以用script来处理文本文件，能够应对复杂的编辑需求。

---

### sed命令语法

<h4><b>基本格式 sed [option] [filename]</b></h4>
<h5><b>选项:</b></h5>  

+ `-e <script>` 按script编辑文本并输出到控制台，但不修改原文件内容
+ `-f filename` 调用sed脚本文件
+ `-i` 直接修改读取的文件内容，而不输出到终端
+ `-n` 使用安静模式，只有经过sed处理的行才会被显示出来
+ `-r` 使用延伸型的正则表达式语法，预设的是基础的正则语法

<h5><b>动作命令[n1[,n2]] function</b></h5>
n1,n2表示起始行和结束行，不一定存在，而function表示动作行为
<h5><b>常用function命令:</b></h5>
+ `a` 新增一行内容（在指定行的下一行）
+ `c` 取代内容，可取代n1,n2之间的行
+ `d` 删除行
+ `i` 插入一行内容（在指定行的上一行）
+ `p` 列印，将某个选择的资料印出，常与`sed -n`连用
+ `s` 取代，搭配正则表达式，替换文本中的内容

---

### sed命令示例
1\. 行的删除：`ls -lha | nl | gsed '1,3d'`删除输出中的第1到第3行，此时参数`-e`可不加。

![sed delete]({{site.baseurl}}/pics/sed_d.png)

2\. 行的插入：

+ 在指定行前插入 `gsed '4a 插入的第一行\n插入的第二行' testSed`
+ 在指定行后插入  `gsed '1i 插入的第一行\n插入的第二行' testSed`  
若要让操作更新到原文件中，需加`-i`，该操作较为危险。建议使用`gsed -i.bak '1i test' testSed`这样的执行方式，通过这种方式可额外生成`testSed.bak`文件，该文件保存了原始内容，这样更安全。

![sed insert]({{site.baseurl}}/pics/sed_insert.png)

3\. 行的选择性显示：
有时会显示文件中某个区间内容的需求，这时通过`gsed -n`可以做到。  
`gsed -n '2,$p' testSed`

![sed print]({{site.baseurl}}/pics/sed_n.png)

4\. 搜索并执行命令：

+ 搜索含有关键字的行：`gsed -n '/^第.行/p' testSed`

![sed search and print]({{site.baseurl}}/pics/sed_search.png)

+ 搜索并删除：`gsed '/第四行/d' testSed`

![sed search and remove]({{site.baseurl}}/pics/gsed_sr.png)

+ 执行多组命令：`gsed '/四/{s/行/列/;s/第四列/测试/}' testSed` `s`表示替换，从图中的结果可以看到，这个过程有点类似`SQL的where查询`，后面的命令在前面的执行结果下执行。

![sed search and multiple operations]({{site.baseurl}}/pics/gsed_mul.png)

5\. 内容替换：

+ 区域替换：`gsed '2,3c 替换内容' testSed`

![sed c replace]({{site.baseurl}}/pics/sed_c.png)

+ 搜索替换：`gsed 's/行/列/g' testSed` 如果没有`g`则只替换行内匹配的第一个

![sed g replace]({{site.baseurl}}/pics/gsed_g.png)

6\. 多重编辑：`gsed -e '1i 测试行' -e '1d'  testSed`和`gsed -e '1d' -e '1i测试行'  testSed`，从图中可以看到两者执行的区别，由于`sed`是按行读入缓冲区，处理后再读如下一行，所以多重编辑时命令的顺序对结果有影响。

![sed -e]({{site.baseurl}}/pics/gsed_e.png)

## 2.awk (Mac)

awk时非常强大的文本分析工具，非常适用于生成分析报告。awk会将文本逐行的读入，默认以空格或制表符为分隔符进行切片，然后对切片后的部分分析处理。awk十分强大，实际上它也有自己的编程语言：“样式扫描和处理语言”，其名称源自于创始人Alfred Aho，Peter Weinberger，Brian Kernighan。

### awk语法

<h4><b>基本格式 awk [option] '[codeblock]' [filenames]</b></h4>

codeblock表示代码块区域

+ `-F` 指定域分隔符
+ `-f` 调用脚本
+ `-v` 定义变量

### awk代码块表示方法

	BEGIN {} // { sentence one; sentence two} END {}

+ `BEGIN` 初始代码块
+ `//` 匹配代码块，与sed中的用法类似
+ `{}` 命令代码块，包含多条命令语句，用`;`分隔
+ `END` 结尾代码块，在每一行执行完后运行。

### awk内置变量($取值)

+ `0` 表示当前行所有内容
+ `n` 第n个域的内容
+ `ARGC` 命令行参数个数
+ `ARGV` 命令行参数排列
+ `ENVIRON` 支持队列中系统的环境变量使用
+ `FILENAME` 正在浏览的文件名
+ `FNR` 浏览文件的记录数
+ `FS` 设置输入域的分隔符，等价于`-F`选项，在`BEGIN`时定义
+ `NF` 域的个数
+ `NR` 已经读取的记录个数
+ `OFS` 输出域分隔符
+ `ORS` 输出记录分隔符
+ `RS` 控制记录分隔符

### awk示例

1\. 打印账户和账户对应的shell：`cat -n /etc/passwd | gawk -F ':' '{print $1" "$5}' | gsed '1,10d'`
其中`$1`和`$5`分别表示分割后的第一个和第五个域。

![awk print]({{site.baseurl}}/pics/awk_print.png)

2\. 使用`printf`：`ls -lha | gawk '{printf("owner:%-15s size:%-10s name:%-15s\n",$3,$5,$NF)}'`类似C语言的`printf`。

![gawk printf]({{site.baseurl}}/pics/gawk_printf.png)

3\. 使用`Begin End`：`cat /etc/passwd | gawk -F: 'BEGIN{print "名称-权限"} {print $1"-"$5} END{print "the end!"}' | sed '2,11d' | column -t -s '-'`

![awk begin]({{site.baseurl}}/pics/awk_begin_end.png)

4\. awk中模式匹配的使用：`cat -n /etc/passwd | gawk -F: '/System/{print $1" "$5}'` 搜索包含`System`关键字的行并输出。

![awk search]({{site.baseurl}}/pics/gawk_search.png)
