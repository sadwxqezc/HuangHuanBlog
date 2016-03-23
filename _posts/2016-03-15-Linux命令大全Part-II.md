---
layout: post
title:  "Linux命令大全 Part Two"
date:   2016-03-21 11:47:00 + 0800
categories: Linux
---
* 内容目录
{:toc}

命令后带(Mac)标记的，表示该命令在Mac OSX下测试，其它的在Debian下测试。

### 17\. thefuck命令(Mac)
 
thefuck命令就是用在你想说`fuck`的时候，它能够自动尝试修复有错误的命令
<h4><b>基本格式 fuck [option] </b></h4>  
需要在`~/.bashrc`中设置`eval $(thefuck --alias)`


范例一：<code>git brnch</code>后回车再输入`fuck`
	
![fuck]({{site.baseurl}}/pics/thefuck.png)  

---

### 18\. tar命令(Mac)

tar命令用于文件的解压或压缩
<h4><b>基本格式 tar [main option] [accessibility options] [filename or dir]</b></h4>
<h5><b>main option 主选项 三者有且只能有一个</b></h5>
+ <code>-c</code> 创建新的文件，相当于打包
+ <code>-x</code> 释放文件，相当于拆包
+ <code>-t</code> 列出档案文件的内容，查看已经备份了哪些文件
<h5><b>accessibility options 辅助选项</b></h5>
+ <code>-z</code> 是否需要用gzip压缩或解压，一般格式为.tar.gz或者.tgz
+ <code>-j</code> 是否需要用bzip2压缩或解压，一般格式为.tar.bz2
+ <code>-v</code> 压缩过程中显示文件
+ <code>-f</code> 使用文档名
+ <code>--exclude FILE</code> 压缩过程中不要将File打包</code>
+ <code>-C dir</code> 切换工作目录，参考:[Linux下使用tar命令](http://www.cnblogs.com/li-hao/archive/2011/10/03/2198480.html)

范例一：`tar -xzvf mbadolato-iTerm2-Color-Schemes-a646a1d.tar.gz` 解压到当前文件夹
	
![tar_xzvf]({{site.baseurl}}/pics/tar_xzvf.png)  

范例二：`tar -tf mbadolato-iTerm2-Color-Schemes-a646a1d.tar.gz` 显示压缩包中的文件目录，如果文件是用gizp压缩的需要加z参数
	
![tar_tf]({{site.baseurl}}/pics/tar_tf.png)  

范例三：`tar -cjvf ./test.bz2 ./mbadolato-iTerm2-Color-Schemes-a646a1d` 压缩文件
	
![tar_jcvf]({{site.baseurl}}/pics/tar_jcvf.png)  

---

### 19\. alias命令(Mac)

alias命令用来设定指令的别名，可以使用该命令将较长的命令简化。
<h4><b>基本格式 alias newCmd='originCmd [option]'</b></h4>

范例一：`alias`或者`alias -p`显示已经定义的别名，可用`unalias`命令删除别名
	
![alias]({{site.baseurl}}/pics/alias.png)  

范例二：`alias ll='ls -lhaS'`可以缩短命令长度，如果要使该alias长期有效，需要写在系统环境变量中。

![alias_ll]({{site.baseurl}}/pics/alias_ll.png)  

---

### 20\. chmod命令(Mac)

chmod命令用于设定文件或目录的权限，可以用数字或符号的方式进行设定，这里推荐用符号的方式
<h4><b>基本格式 chmod [option] [filename|dirname]</b></h4>
+ `-R`递归的持续变更 

范例一：`chmod u-x,g+w,o=rwx function.sh`其中`u`表示文件所有者，`g`表示组用户，`o`表示其它用户，`a`表示所有用户。而`-,+,=`分别表示删除，增加和设定权限。
	
![chmod_ugo]({{site.baseurl}}/pics/chmod_ugo.png)  

范例二：`chmod a=rwx function.sh`设定所有类型用户的权限

![chmod_a]({{site.baseurl}}/pics/chmod_a.png)  

参考:[命令行的艺术](https://github.com/jlevy/the-art-of-command-line/blob/master/README-zh.md)

---

### 21\. pv命令(Mac)
 
pv命令可以通过管道来显示数据的处理进度
<h4><b>基本格式 pv [option]</b></h4>
+ <code>-p</code> 显示百分比
+ <code>-t</code> 显示时间		
+ <code>-r</code> 传输速率
+ <code>-e</code> 估计的剩余时间
+ <code>-n</code> 用数字代替进度条来显示百分比
+ <code>-L</code> 限制传输速度

范例一：<code>pv ./12怒汉.mkv > ~/Work/Test/angry.mkv</code> 显示拷贝的速度和百分比 
	
![pv]({{site.baseurl}}/pics/pv.png)  

范例二：<code>echo 'this is a pv test' | pv -L 2</code>  限制传输速度为2Bytes

![pv_L]({{site.baseurl}}/pics/pv_L.png)

---

### 22\. bc命令(Mac)
 
bc命令可以用于计算
<h4><b>基本格式 bc [option]</b></h4>
+ <code>-l</code> 定义数学函数的库，并将初始值scale设定为20

范例一：<code>bc</code>
	
![bc]({{site.baseurl}}/pics/bc.png)  

---

### 23\. uniq命令

参考:[sort命令](http://sadwxqezc.github.io/HuangHuanBlog/linux/2016/02/11/Linux%E5%91%BD%E4%BB%A4%E5%AD%A6%E4%B9%A0-Part-Four.html)
uniq命令通常和sort命令合用，用于检查文本中重复出现的行列，但前提是重复行必须是相邻的。
<h4><b>基本格式 uniq [option] [filename] [outputfilename]</b></h4>
+ <code>-c</code> 显示该行重复出现的次数
+ <code>-d</code> 仅仅显示重复出现的行列
+ <code>-u</code> 仅显示出现一次的行列

范例一：`sort sort.txt | uniq -c`等命令结果
	
![uniq]({{site.baseurl}}/pics/uniq.png)  

一个好玩的命令站点：[Commandlinefu](http://www.commandlinefu.com/commands/browse/sort-by-votes)

![command]({{site.baseurl}}/pics/command.png)

---

### 24\. curl命令(Mac)

curl命令是一个非常强大的文件传输工具，利用，利用URL规则它支持文件的上传和下载。curl支持包括HTTP,HTTPS,Ftp等多种协议，同时支持Post，cookies，限速，认证等众多功能。

<h4><b>基本格式 curl [option] [params]</b></h4>
+ <code>-A</code> 设置用户代理
+ <code>-c [file]</code> 命令执行结束后将cookie写入到某个文件中
+ <code>-C [offset]</code> 断点续传
+ <code>-e </code>  设定来源网址
+ <code>-s </code> 寂寞模式，不输出任何东西
+ <code>-S </code> 显示错误
+ <code>-T [file] </code> 上传文件
+ <code>-u </code> 设置用户名和密码
+ <code>-o [filename]</code> 将文件写入到某个文件中
+ <code>-O </code> 将文件写入到本地文件，保存原始文件名

范例一：`curl http://man.linuxde.net/test.iso -o filename.iso --progress` 下载文件并显示进度条
	
![curl_o]({{site.baseurl}}/pics/curl_o.png)  

该命令功能较多，今后将进一步补充

---

### 25\. top和free命令

top命令实际上就是Linux下的“任务管理器”，能够实时的显示系统中各个进程的资源占用状况，默认刷新频率是5秒一次。

<h4><b>基本格式 top [option]</b></h4>

快捷键：

+ `P` 根据CPU占用排序
+ `M` 根据内存使用大小排序
+ `T` 根据时间/累计时间排序

范例一: `top` 显示效果，前五行显示了启动时间，任务数，cpu，内存和交换分区等信息，之后是更详细的各个进程信息。

![top]({{site.baseurl}}/pics/top.png)

范例二: `free -m` 如果只想查看内存占用，同样可使用`free`命令，一般选择按`MB`显示。

![free]({{site.baseurl}}/pics/free.png)

---

### 26\. paste命令(Mac)

paste命令用于将多个文件的内容合并

<h4><b>基本格式 paste [option] [filename]</b></h4>
+ `-s` 串行处理而非平行
+ `-d` 设定间隔符号

范例：`paste -s -d ':' test2 test1`

![paste]({{site.baseurl}}/pics/paste.png)

---

### 27\. cut命令(Mac)

cut命令用于在文件中剪切数据，以每一行为处理对象。

<h4><b>基本格式 cut [option] [filename]</b></h4>

+ `-b` 按字节分割，空格算一个字节，汉字三个字节
+ `-c` 按字符分割
+ `-f` 按域分割
+ `-d` 指定域分隔符

范例一: `date | cut -b 1-7,9` 

![cut_b]({{site.baseurl}}/pics/cut_b.png)

范例二: `date | cut -c 1-5`

![cut_c]({{site.baseurl}}/pics/cut_c.png)

范例三: `date | cut -d " " -f 1-5 testColumn`

![cut_f]({{site.baseurl}}/pics/cut_f.png)

---

### 28\. lsof命令

在Linux中，一切都以文件的形式存在，包括常规数据，网络连接和硬件。而lsof(list open files)命令能够列出当前系统打开的文件，通过该命令可以查看进程和文件的占用关系。

<h4><b>基本格式 lsof [option] [filename]</b></h4>

+ `-c` 显示进程打开的文件
+ `-p` 显示某进程号的进程打开的文件 
+ `-i [46][TCP|UDP][@hostname|hostaddr][:service|port]` 显示符合条件的进程情况

<h4>显示的内容：</h4>

+ `COMMAND` 进程名称
+ `PID` 进程id
+ `USER` 进程所有者
+ `FD` 文件描述符
+ `DEVICE` 指定磁盘的名称
+ `SIZE` 文件大小
+ `NODE` 索引节点（文件在磁盘的标志）
+ `NAME` 打开文件的确切名称（带绝对路径）

范例一：`lsof -i:5000` 该命令的作用类似于`netstat -anp | grep 5000`，可以根据端口号，查看是哪个进程占用了5000端口。

![lsof -i port]({{site.baseurl}}/pics/lsof_i.png)

范例二：`lsof catlina.out` 查看tomcat的logs文件中的日志文件被占用情况

![lsof file]({{site.baseurl}}/pics/lsof.png)

### 有趣的命令

范例一：`cal -j 2 2016`  
显示2016年2月份的日历，标注当天为一年中的第几天
    
![cal]({{site.baseurl}}/pics/cal.png)

范例二：screen在一个窗口中开启多个虚拟链接，适用于在screen的虚拟链接中运行脚本,不用再开新的窗口
	
	screen -S yourname //创建一个名为yourname的虚拟链接
	jekyll serve //在yourname中启动一个jekyll
	ctrl+a,d //保存并返回
	screen -ls //查看所有的screen
	screen -r yourname //返回该screen

![screen]({{site.baseurl}}/pics/screen.png)

范例三：column命令可以用于格式化文本，但仅仅适用于较为简单的文本

![column]({{site.baseurl}}/pics/column.png)

范例四：file命令可以查看对象类型

![file]({{site.baseurl}}/pics/file.png)

范例五：xargs命令的作用时将参数分段传输给其它命令，后面加-n1表示每次传入一个参数，-n2表示传入两个参数。

![xargs]({{site.baseurl}}/pics/xargs.png)

范例六：basename命令可用于去除文件的前缀，只获取文件名。

![basename]({{site.baseurl}}/pics/basename.png)

---

### 几个好玩的命令（Mac）

范例一：`espeak haliluya` 文本转语音命令，颇为有趣。Mac下可用`brew`安装。

范例二：`man ascii` 可以方便的显示ascii 表

![ascii]({{site.baseurl}}/pics/ascii.png)

范例三：`time read`计时器，按`Ctrl+D`结束

![time]({{site.baseurl}}/pics/time_read.png)