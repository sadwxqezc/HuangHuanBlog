---
layout: post
title:  "Linux命令学习的日常 Part Five"
date:   2016-02-16 10:10:00 ＋8000
categories: Linux
---

### Linux命令(系统 Debian)

## 1\. ps命令
 
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

## 2\. tmux命令(Mac OSX)
 
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