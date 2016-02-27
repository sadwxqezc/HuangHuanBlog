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