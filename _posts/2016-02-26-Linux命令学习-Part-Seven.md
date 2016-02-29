---
layout: post
title:  "Linux命令学习的日常 Part Seven"
date:   2016-02-25 10:52:00 ＋8000
categories: Linux
---

## 1. uniq命令(Linux)

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

## 几个好玩的命令（Mac OSX）

范例一：`espeak haliluya` 文本转语音命令，颇为有趣。Mac下可用`brew`安装。

范例二：`man ascii` 可以方便的显示ascii 表

![ascii]({{site.baseurl}}/pics/ascii.png)

范例三：`time read`计时器，按`Ctrl+D`结束

![time]({{site.baseurl}}/pics/time_read.png)

## 2. curl命令(Mac OSX)

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

## 3. top命令(Linux)

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
