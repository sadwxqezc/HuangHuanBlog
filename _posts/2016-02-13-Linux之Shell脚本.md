---
layout: post
title:  "Shell脚本学习"
date:   2016-02-13 23:49:00 ＋8000
categories: Shell
---


## 范例代码(Mac下)

以一段Git代码提交脚本为例：
  
	# 添加目录下所有文件
	git add . 
	# message为git commit的值，默认值为当前时间，``间包含字符串将被按照命令执行。
	message=`date +%Y-%m-%d-%H-%M`
	# getopts命令可获取输入的参数，如m:则表示检查'-m'的参数输入，并将参数名存入opt中。
	# 如果未找到参数，则存入?,参数值通过OPTARG变量获得，变量通过$取值。
	
	while getopts m: opt
	do
	case $opt in
	     m)
           message=$OPTARG
           ;;
         ?)
           echo "Usage: args [-m]"
           echo "-m means message"
           echo "exit"
           exit
           ;;
    esac
    done
    # git提交message信息
	git commit -m "$message""
	git push origin gh-pages

Git代码提交脚本执行效果截图：

![Git代码提交]({{site.baseurl}}/pics/git_shell.png)

To be continued

