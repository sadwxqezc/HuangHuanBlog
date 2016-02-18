---
layout: post
title:  "Linux命令学习的日常 Part Three"
date:   2016-02-07 21:19:00 ＋8000
categories: Linux
---

### Linux命令(系统 Debian)

## 1\. tail命令
 
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

## 2\. head命令

该命令与tail命令类似，默认显示文件前两行的内容
<h4><b>基本格式 head [option] [filename]</b></h4>
+ <code>-n number</code> 显示前几行,-5表示文件中除了最后5行之外的所有内容
+ <code>-c number</code> 显示前几个字节

范例一：<code>head -n 5 server.xml</code>和<code>head -n －5 server.xml</code>

![head_n]({{site.baseurl}}/pics/head_n.png)

## 3\. du命令

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

## 4\. which命令和whereis命令

which命令的作用是在PATH变量制定的路径中，查找系统命令的位置。  
whereis命令用于程序名的搜索，且只能搜索｛二进制文件，man说明文件，源代码文件｝。whereis的查询时通过查询系统的数据库文件记录，所以速度比find更快，但由于数据库的更新频率较为缓慢，其结果与实际状况并不一定一致。

+ <code>-m</code> 只查找说明文件
+ <code>-b</code> 只查找二进制文件

范例一：which命令

![which]({{site.baseurl}}/pics/which.png)

范例二：whereis命令

![whereis]({{site.baseurl}}/pics/whereis.png)

