---
layout: post
title:  "Linux命令的艺术学习笔记"
date:   2016-02-19 16:52:00 ＋8000
categories: Linux
---

来源于:[命令行的艺术](https://github.com/jlevy/the-art-of-command-line/blob/master/README-zh.md)


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
