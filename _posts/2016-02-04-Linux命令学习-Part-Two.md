---
layout: post
title:  "Linux命令学习的日常 Part Two"
date:   2016-02-04 16:50:00 ＋8000
categories: Linux
---
* 内容目录
{:toc}

### 1\. find命令
 
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

### 2\. wc命令

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

### 3\. cat命令

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
