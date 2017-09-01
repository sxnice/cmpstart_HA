#!/bin/bash
#set -x
set -eo pipefail
shopt -s nullglob
source ./colorecho


#---------------可修改配置参数------------------
#安装目录
CURRENT_DIR="/springcloudcmp"
#用户名
cmpuser="cmpimuser"
#-----------------------------------------------
declare -a SSH_HOST=()

#建立对等互信
ssh-interconnect(){
	echo_green "建立对等互信开始..."
	local ssh_init_path=./ssh-init.sh
        #从文件里读取ip节点组
        for line in $(cat haiplist)
        do
		$ssh_init_path $line
	done
	echo_green "建立对等互信完成..."
}

#启动cmp
start_internode(){
	echo_green "启动CMP开始..."
	#启动主控节点1或集中式启动串行启动！
	local k=0
	#从文件里读取ip节点组，一行为一个组
        cat haiplist | while read line
        do
                SSH_HOST=($line)
                echo "启动节点组"
		for i in "${SSH_HOST[@]}"
		do
			echo "启动节点"$i
			ssh $i <<EOF
			su - $cmpuser
			source /etc/environment
			umask 077
			cd "$CURRENT_DIR"
			./startIM.sh
			exit
EOF
			echo "节点"$i"启动完成"
			break
		done
		
		#启动其他节点!
		for i in "${SSH_HOST[@]}"
		do
		if [ "$k" -eq 0 ];then
			let k=k+1
			continue
		fi
		echo "启动节点"$i
		 ssh $i <<EOF
		 su - $cmpuser
		 source /etc/environment
		 umask 077
		 cd "$CURRENT_DIR"
		 ./startIM_BX.sh
		 exit
EOF
		let k=k+1
		echo "发启启动指令成功"
		done
		
		#检测其他节点服务是否成功!
		k=0
		for i in "${SSH_HOST[@]}"
		do
		if [ "$k" -eq 0 ];then
			let k=k+1
			continue
		fi
		echo "检测节点"$i
		 ssh $i <<EOF
		 su - $cmpuser
		 source /etc/environment
		 umask 077
		 cd "$CURRENT_DIR"
		 ./imstart_chk.sh
		 exit
EOF
		let k=k+1
		echo "节点检测成功"
		done
	done
	echo_green "启动CMP完成..."
}

#关闭cmp
stop_internode(){
	echo_green "关闭CMP开始..."
	#从文件里读取ip节点组，一行为一个组
        cat haiplist | while read line
	do
                SSH_HOST=($line)
                echo "关闭节点组"
		for i in "${SSH_HOST[@]}"
		do
		echo "关闭节点"$i
		local user=`ssh $i cat /etc/passwd | sed -n /$cmpuser/p |wc -l`
		if [ "$user" -eq 1 ]; then
			local jars=`ssh $i ps -u $cmpuser | grep -v PID | wc -l`
			if [ "$jars" -gt 0 ]; then
				ssh $i <<EOF
				killall -9 -u $cmpuser
				exit
EOF
				echo "complete"
			else
				echo "CMP已关闭"
			fi
		else
			echo_red "尚未创建$cmpuser用户,请手动关闭服务"
			exit
		fi
		done
	done
	echo_green "所有节点CMP关闭完成..."
}

#批量关cmpim服务
ssh-interconnect
stop_internode
