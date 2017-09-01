# cmpstart
**********准备工作***************
1、packages放依赖包，jdk1.8(需上传解压后的文件),mysql5.7.19(需上传解压后的文件),jce(需上传jce文件);
2、将mysqlha_MM的my.cnf,放至mysql_5.7.19/support-files目录下，并命名为my-default.cnf;
3、将mysqlha_MM的my-master.cnf，my-slave.cnf，mysql.server放至mysql_5.7.19/support-files目录下;
4、配置好springcloudcmp下的haiplist,im.config文件;
5、支持centos6,centos7,ubuntu14.04的一键安装。

********************************
安装平台流程-----------------------
1、建立ssh互信；
2、检测依赖包及JDK1.8；
3、安装redis;
4、安装mongo;
5、创建普通用户；
6、复制文件到各节点；
7、配置环境变量；
8、安装keepalived;
9、配置权限；
10、配置iptables；
11、启动cmp。
