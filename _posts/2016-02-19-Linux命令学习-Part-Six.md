---
layout: post
title:  "Linux命令学习的日常 Part Six"
date:   2016-02-23 11:36:00 ＋8000
categories: Linux
---

## 1. tar命令(Mac OSX)

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

## 2. alias命令(Mac OSX)

alias命令用来设定指令的别名，可以使用该命令将较长的命令简化。
<h4><b>基本格式 alias newCmd='originCmd [option]'</b></h4>

范例一：`alias`或者`alias -p`显示已经定义的别名，可用`unalias`命令删除别名
	
![alias]({{site.baseurl}}/pics/alias.png)  

范例二：`alias ll='ls -lhaS'`可以缩短命令长度，如果要使该alias长期有效，需要写在系统环境变量中。

![alias_ll]({{site.baseurl}}/pics/alias_ll.png)  

## 3. chmod命令(Mac OSX)

chmod命令用于设定文件或目录的权限，可以用数字或符号的方式进行设定，这里推荐用符号的方式
<h4><b>基本格式 chmod [option] [filename|dirname]</b></h4>
+ `-R`递归的持续变更 

范例一：`chmod u-x,g+w,o=rwx function.sh`其中`u`表示文件所有者，`g`表示组用户，`o`表示其它用户，`a`表示所有用户。而`-,+,=`分别表示删除，增加和设定权限。
	
![chmod_ugo]({{site.baseurl}}/pics/chmod_ugo.png)  

范例二：`chmod a=rwx function.sh`设定所有类型用户的权限

![chmod_a]({{site.baseurl}}/pics/chmod_a.png)  

<br/>
参考:[命令行的艺术](https://github.com/jlevy/the-art-of-command-line/blob/master/README-zh.md)

## 冷门但有用的命令(Mac OSX)


## 1\. pv命令
 
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

## 2\. bc命令
 
bc命令可以用于计算
<h4><b>基本格式 bc [option]</b></h4>
+ <code>-l</code> 定义数学函数的库，并将初始值scale设定为20

范例一：<code>bc</code>
	
![bc]({{site.baseurl}}/pics/bc.png)  


