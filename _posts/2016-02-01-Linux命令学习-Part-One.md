---
layout: post
title:  "Linux命令学习的日常 Part One"
date:   2016-02-01 12:00:00 ＋8000
categories: Linux
---


### Linux&Unix通用命令(系统Mac OS)
1\. grep命令
 
> 文本查找命令, 能够使用正则表达式的方式搜索文本，其搜索对象可以是单个或则多个文件
> 
> > <h4><b>基本格式 grep [option] [regex] [path]</b></h4>
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

2\. ls命令

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

3\. 有趣的命令

	范例一：cal -j 2 2016
	显示2016年2月份的日历，标注当天为一年中的第几天
    
![cal]({{site.baseurl}}/pics/cal.png)

	范例二：screen在一个窗口中开启多个虚拟链接，适用于在screen的虚拟链接中运行脚本,
	不用再开新的窗口
	
{% highlight bash linenos %}
screen -S yourname //创建一个名为yourname的虚拟链接
jekyll serve //在yourname中启动一个jekyll
ctrl+a,d //保存并返回
screen -ls //查看所有的screen
screen -r yourname //返回该screen
{% endhighlight %}

![screen]({{site.baseurl}}/pics/screen.png)

	范例三：column命令可以用于格式化文本，但仅仅适用于较为简单的文本

![column]({{site.baseurl}}/pics/column.png)

	范例四：file命令可以查看对象类型

![file]({{site.baseurl}}/pics/file.png)

    范例五：xargs命令的作用时将参数分段传输给其它命令

![xargs]({{site.baseurl}}/pics/xargs.png)



