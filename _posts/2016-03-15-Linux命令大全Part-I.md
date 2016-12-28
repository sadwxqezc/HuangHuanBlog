---
layout: post
title:  "Linux命令大全 Part One"
date:   2016-03-14 16:24:00 +0800
categories: Linux
---
* 内容目录
{:toc}

命令后带(Mac)标记的，表示该命令在Mac OSX下测试，其它的在Debian下测试。

### 1\. grep命令
 
> 文本查找命令, 能够使用正则表达式的方式搜索文本，其搜索对象可以是单个或则多个文件
> 
> > <h4><b>基本格式 grep [option] [regex] [path]</b></h4>
> > -o 只按行显示匹配的字符  
> > -c 只输出匹配行的数目  
> > -n 显示匹配行的行号  
> > -v 显示不包含匹配文本的行  
> > -i 不区分大小写 (grep是大小写敏感的)  
> > -R 文件夹下递归搜索  
> > -l 只显示匹配的文件名    
> > -H 显示文件名  
> > -A NUM(after)显示匹配的后几行  
> > -B NUM(before)显示匹配的前几行  
> > -C NUM显示匹配的前后几行    
> > --color 标出颜色  

	范例一：man grep | grep --color=always -n search
	带颜色的文本搜索，并同时输出行号
	
![带颜色的搜索]({{site.baseurl}}/pics/grep_color_n.png)  

	范例二：man grep | grep --color=always -n '\<search\>'
	正则表达式模式的搜索
	
![正则表达式的搜索]({{site.baseurl}}/pics/grep_color_n_regex.png)

	范例三：grep -nR --color=always  a ./*.yml
	在文件夹下的yml文件中搜索，并标注行号和对应行
	
![文件夹搜索]({{site.baseurl}}/pics/grep_dir.png)
	
	范例四：grep -lR a ./*.yml
	在文件夹下的yml文件中搜索，但只输出匹配的文件名
	
![文件夹搜索]({{site.baseurl}}/pics/grep_dir_only.png)

---

### 2\. ls命令

> ls是命令行中用的最多的命令之一了，用于显示目录下的文件
>
> > <h4><b>基本格式 ls [option]</b></h4>
> > -a 列出所有文件，包括'.'开头的隐藏文件  
> > -h 使打印结果易于使用者查看(human readable)  
> > -l 列出文件的详细信息：创建者，创建时间，读写权限等  
> > -s 显示文件大小  
> > -t 按时间进行文件的排序  
> > -S 以大小进行排序  
> > -r 当前条件逆序  
> > -L 显示文件链接名  
> > -R 将目录中所有文件都递归显示出来  

	范例一：ls -lharts
    输出文件信息，并时间从旧到新排列
    
![详细信息]({{site.baseurl}}/pics/ls_r_t.png)

	范例二：ls -R
	递归输出目录下的所有文件
	
![ls递归]({{site.baseurl}}/pics/ls_R.png)

---

### 3\. find命令
 
> 文件查找命令,find命令将递归的搜索目录下符合要求的所有文件
> 
> > <h4><b>基本格式 find [path] [option] [expression]</b></h4>
> > -name 查找名为filename的文件  
> > -perm 查找符合执行权限
> > -user 按照文件的所属主查找  
> > -mtime -n +n 按照文件的更改时间查找文件，n代表天数  
> > -ctime -n +n 按照创建时间查找  
> > -newer f1 !f2 查更改时间在f1和f2之间的文件      
> > -size n 查找长度为n块的文件，一块为512 bytes  
> > -depth 使得查找在进入子目录前先行查找完本目录  
> > -prune 查找时忽略某个目录
> > -type 按文件类型查找，b为块设备，d为目录，f为普通文档 

	范例一：find ~ -name '*.yml' | grep '\.yml' --color=always
	在用户目录下查找文件名后缀为.yml的文件
	
![按照文件名查找]({{site.baseurl}}/pics/find_name.png)  

	范例二：find . -perm 644
	查找当前目录下权限为644的所有文件
	
![按照权限的搜索]({{site.baseurl}}/pics/find_perm.png)

	范例三：find . -path './_site*' -a -prune -o -name 'feed.xml' -print
	整个语句是在当前目录下查找名为feed.xml的文件，同时需要忽略./_site*路径的文件。
	-a -o实际为逻辑与和逻辑或，当路径匹配时将执行-prune，那么将不会查找匹配路径中的文件，
	当路径不匹配时则不执行-prune，-o后的语句始终执行。
	
![忽略一些文件夹搜索]({{site.baseurl}}/pics/find_prune.png)
	
	范例四：find . -maxdepth 2 -size 3
    控制查找的深度
	
![限制搜索深度]({{site.baseurl}}/pics/find_depth.png)

补充：Linux的权限模式为三元组“owner”，“group”，“other”,权限对应表如下  

rwx | 7 | \-wx | 3
rw\- | 6 | \-w\- | 2
r\-x | 5 | \-\-x | 1
r\-\- | 4 | \-\-\- | 0

---

### 4\. wc命令

> 用于统计输入中的字节数，字数，行数并输出
> 
> > <h4><b>基本格式 wc [option] [filename]</b></h4>
> > -c 统计字节数  
> > -l 统计行数  
> > -m 统计字符数  
> > -w 统计字数，一个字为由空白，跳格或换行字符分隔的字符串   

	范例一：wc -l _config.yml
	统计行数，-c实际上可以查看文件的大小
	
![统计]({{site.baseurl}}/pics/wc.png)  

---

### 5\. cat命令

> 连结命令(Concatenation)，连结多个文本，或者以标准输出形式打印文件的内容
> 
> > <h4><b>基本格式 cat [option] [filename]</b></h4>  
> > -n 队输出的所有行编号  
> > -b 与-n类似，但空行不编号      

	范例一：cat -b testColumn(cat -n testColumn)
	显示文件内容
	
![显示文件内容到控制台]({{site.baseurl}}/pics/cat_b_n.png)

	范例二：cat testColumn testCat
	同时显示两个文件内容

![显示两个文件]({{site.baseurl}}/pics/cat_mul.png)

	范例三：cat testColumn testCat>merge
	将两个内容连结并输出到一个文件中，>为重新创建，>>为追加

![连结并输出]({{site.baseurl}}/pics/cat_merge.png)

---

### 6\. tail命令
 
文本查看命令，可以看文本的最后几行。tail命令的优点在于其内容能够与输入同步更新，非常适用于查看实时日志。
<h4><b>基本格式 tail [option] [filename]</b></h4>
+ <code>-n number</code> 定位参数，+5表示从第五行开始显示，10或-10表示显示最后10行
+ <code>-f</code> 监控文本变化，更新内容
+ <code>-k number</code> 从number所指的KB处开始读取

范例一：<code>tail -n -5 catalina.out</code>
输出最后5行
	
![tail_n]({{site.baseurl}}/pics/tail_n.png)  

范例二：<code>tail -f catalina.out</code>
监听catalina.out最后行的变化并显示

![tail_f]({{site.baseurl}}/pics/tail_f.png)

---

### 7\. head命令

该命令与tail命令类似，默认显示文件前两行的内容
<h4><b>基本格式 head [option] [filename]</b></h4>
+ <code>-n number</code> 显示前几行,-5表示文件中除了最后5行之外的所有内容
+ <code>-c number</code> 显示前几个字节

范例一：<code>head -n 5 server.xml</code>和<code>head -n －5 server.xml</code>

![head_n]({{site.baseurl}}/pics/head_n.png)

---

### 8\. du命令

该命令用于查看系统中文件和目录所占用的空间
<h4><b>基本格式 du [option] [name]</b></h4>  
+ <code>-h</code> 用human readable的方式显示  
+ <code>--max-depth=number</code> 最大的查询层次  
+ <code>-a</code> 显示所有文件的大小，默认只显示目录的大小  

范例一：<code>du -h</code> 显示目录下所有文件夹的大小  

![du]({{site.baseurl}}/pics/du.png)

范例二：<code>du -h catalina.out</code>和<code>du -h ../logs</code> 显示文件或目录的大小  

![du_name]({{site.baseurl}}/pics/du_name.png)

范例三：<code>du -ah --max-depth=1</code>显示递归的层次为1，显示所有文件和文件夹大小  

![du_max_depth]({{site.baseurl}}/pics/du_max_depth.png)

---

### 9\. which和whereis

which命令的作用是在PATH变量制定的路径中，查找系统命令的位置。  
whereis命令用于程序名的搜索，且只能搜索｛二进制文件，man说明文件，源代码文件｝。whereis的查询时通过查询系统的数据库文件记录，所以速度比find更快，但由于数据库的更新频率较为缓慢，其结果与实际状况并不一定一致。

+ <code>-m</code> 只查找说明文件
+ <code>-b</code> 只查找二进制文件

范例一：which命令

![which]({{site.baseurl}}/pics/which.png)

范例二：whereis命令

![whereis]({{site.baseurl}}/pics/whereis.png)

---

### 10\. sort命令
 
sort命令用于对文本进行排序，并将结果输出。其以文本的每一行为单位，从首字符向后，依次按照ascii码值进行比较，最后升序排列。（默认是忽略每行前面空格的）
<h4><b>基本格式 sort [option] [filename]</b></h4>
+ <code>-u</code> 忽略重复行
+ <code>-n</code> 按照数字大小排序
+ <code>-r</code> 逆序
+ <code>-k start,end</code>start为比较的起始位置，end为结束位置

范例一：<code>sort sort.txt</code> 排序
	
![sort]({{site.baseurl}}/pics/sort.png)  

范例二：  
1. <code>sort -nk 2 -t - sort.txt</code> 以`-`进行分割，对分割后的第二个域进行排序；  
2. <code>sort -nrk 2 -t - sort.txt</code> 逆序排序

![sort_t]({{site.baseurl}}/pics/sort_t.png)

范例三：<code>sort -t - -k 1.7 -nk 3,3 sort_k.txt</code>  
`-k start,end`中end可以省略，上面的`1.7`表示分割后第一个域的第7个字符，由于没有`end`，则表示对第一个域中第7字符及其之后的字符排序。而`3,3`则表示在前面排序的基础上，再对第三个域进行排序。

![sort_k]({{site.baseurl}}/pics/sort_k.png)

---

### 11\. netstat命令

netstat用于输出linux系统的网络情况信息，以前面试的时候还被问过：“如何查看占用某个端口的程序的pid?"，这个问题实际用<code>netstat -anp</code>输出，然后再grep一下即可。
<h4><b>基本格式 netstat [option]</b></h4>
+ <code>-a</code> 显示所有socket连接
+ <code>-l</code> 显示监控中(listening)的socket连接
+ <code>-n</code> 直接使用ip地址，而不使用域名服务器
+ <code>-p</code> 显示正在使用socket的程序的pid和名称
+ <code>-r</code> 打印路由表
+ <code>-t</code> 显示TCP传输协议的连线状况
+ <code>-u</code> 显示UDP传输协议的连线状况
+ <code>-s</code> 显示网络工作信息统计表

范例一：<code>netstat -anp</code>
显示程序的pid和名称

![netstat 端口]({{site.baseurl}}/pics/netstat_anp.png) 

范例二：<code>netstat -r</code>
输出本机路由表

![netstat 路由表]({{site.baseurl}}/pics/netstat_r.png)

范例三：<code>netstat -lts</code>
输出监听状态中的tcp协议统计信息

![netstat tcp统计]({{site.baseurl}}/pics/netstat_lts.png)

---

### 12\. more命令

more命令用于显示文件的内容，与cat和tail等命令不同的是，more命令是按页显示文件内容，同时具有搜寻字符串的功能。（由于more具有向前翻页功能，因此该命令会加载整个文件）

<h4><b>基本格式 more [option] [filename]</b></h4>
+ <code>+n</code> 从第n行开始显示
+ <code>-n</code> 定义屏幕大小为n行
+ <code>+/pattern</code> 再显示前按pattern匹配子串并显示
+ <code>-s</code> 把连续的多个空行显示为一行

	常用操作命令：
	<ul>
	<li>Enter 向下n行，默认为1行</li>
	<li>Ctrl+F 跳过一屏</li>
	<li>Ctrl+B 返回上一屏</li>
	<li>空格键 向下滚动一屏</li>
	<li>= 输出当前行的行号</li>
	<li>在more模式中回车，输入<code>/pattern</code>可以持续向下搜索</li></ul>
	
范例一：<code>more +/Deploy catalina.out</code>  
在catalina.out文件中查找“Deploy字符第一次出现的位置”，并从该处的前两行开始显示输出

![more 搜索]({{site.baseurl}}/pics/more_+.png) 

范例二：<code>more +10 -10 catalina.out</code>  
从第10行开始，每页10行

![more 参数]({{site.baseurl}}/pics/more_+_-.png)

---

### 13\. less命令

less命令与more命令对应，既可以前后翻看文件，同时还有前后搜索功能，除此之外，less在查看前不会加载整个文件。

<h4><b>基本格式 less [option] [filename]</b></h4>
+ <code>－N</code> 显示每行的行号
+ <code>-i</code> 忽略搜索时的大小写
+ <code>-s</code> 将连续空行显示为一行
+ <code>-m</code> 显示百分比

	常用操作命令：
	<ul>
	<li>/字符串 向下搜索“字符串”功能</li>
	<li>?字符串 向上搜索“字符串”功能</li>
	<li>n 重复前一个搜索</li>
	<li>空格键 滚动一页</li>
	<li>d 滚动半页</li>
	<li>b 回溯一页</li>
	<li>y 回溯一行</li>
	<li>q 退出less命令</li>
	</ul>
	
范例一：<code>less -Nm catalina.out</code>  
显示行号和百分比

![less 行号百分比]({{site.baseurl}}/pics/less_Nm.png) 

范例二：<code>/detail</code>或者<code>?detail</code>
向前向后搜索"detail"

![less 搜索]({{site.baseurl}}/pics/less_search.png)

---

### 14\. ps命令
 
ps命令用来在Linux系统中显示进程的状态快照，其参数选项可谓非常之多。
<h4><b>基本格式 ps [option]</b></h4>
+ <code>-a</code> 显示所有用户的进程
+ <code>-x</code> 显示没有控制终端的进程
+ <code>-u</code> 按照用户名称查询进程
+ <code>-f</code> 列出全部信息，常和其它选项联用
+ <code>-j</code> 用任务格式来显示进程
+ <code>-e</code> 显示所有进程

范例一：<code>ps -ef</code> 用标准格式显示所有进程  
显示的项目有：UID, PID, PPID(父进程ID), C(CPU资源百分比), STIME, TTY, TIME, CMD
	
![ps_ef]({{site.baseurl}}/pics/ps_ef.png)  

范例二：<code>ps aux</code>  
显示的项目有：USER, PID, %CPU, %MEM, VSZ(虚拟内存量KB), RSS(固定内存量), TTY(进程所运行在的终端机), STAT, START, TIME, COMMAND

![ps_aux]({{site.baseurl}}/pics/ps_aux.png)

---

### 15\. tmux命令(Mac)
 
tmux(Terminal Multiplexer)命令是一个颇为炫酷的命令，其特点与screen命令类似。tmux通过开出窗口，分拆面板，接管和分离会话，能够让使用者在一个窗口内同时进行多项操作。  
tmux在osx的安装方式：<code>brew install tmux</code>  
<h4><b>基本格式 tmux [option]</b></h4>
+ <code>tmux new -s sessionName</code> 创建新的session会话
+ <code>tmux attach -t sessionName</code> 重新连接上某一个session
+ <code>tmux kill-session -t sessionName</code> 杀死某个session
+ <code>tmux ls</code> 显示所有会话

范例一：<code>tmux new -s mySession</code> 创建一个名为mySession的会话  
输入`CTRL+b d`将从此会话脱离，如果要重新连接，则使用`tmux attach -t mySession`

![tmux_new]({{site.baseurl}}/pics/tmux_mySession.png)  

范例二：在范例一的mySession中按下`CTRL+b c`则会在mySession中创建一个新的窗口  
可以通过`CTRL+b w`来查看窗口列表，`CTRL+b <窗口号>`来切换窗口  
`CTRL+b f`来查找窗口，`exit`来退出窗口

![tmux_multiple]({{site.baseurl}}/pics/tmux_windows.png)

为了便于穿窗口的识别，还可以通过`CTRL+b ,`来重命名窗口

![tmux_rename]({{site.baseurl}}/pics/tmux_rename.png)

范例三：tmux还支持把窗口分割成多个面板，`CTRL+b "`为水平分割，`CTRL+b %`为垂直分割  
通过`CTRL+b <光标键>`来进行窗口移动

![tmux_panes]({{site.baseurl}}/pics/tmux_panes.png)

---

### 16\. ack命令(Mac)
 
ack(better than grep)命令的作用和grep类似，但效果更好。
<h4><b>基本格式 ack [option] [pattern]</b></h4>
+ <code>-w</code> 按单词匹配
+ <code>--ingore-dir</code> 忽略某些目录


范例一：<code>ack -w 测试</code> 与grep搜索的对比
	
![ack_w]({{site.baseurl}}/pics/ack_w.png)  

---

### 17\. kill命令

kill命令用于终止指定的进程，其工作原理是通过向进程发送指定的信号。

<h4><b>基本格式 kill [params] [pid]</b></h4>

常用的是：

	kill -9 pid //强制终止
	
+ `-1` Hup 终端断线
+ `-2` INT 中断（同`Ctrl+c`）
+ `-3` QUIT 退出(同`Ctrl+\`)
+ `-15` TERM 终止，是默认的信号，如果应用本身会捕获该信号，则不能终止
+ `-9` KILL 强制终止
+ `-18` CONT 继续
+ `-19` STOP 暂停(同`Ctrl+z`)
