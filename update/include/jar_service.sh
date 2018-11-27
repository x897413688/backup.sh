#/bin/bash

function service()
{
for ips in {118..131}
do
	if [[ $ips -eq 118 || $ips -eq 131 ]]
	then
	for line in `cat /media/update/file_name/jars`;do
               if ssh  172.31.69.$ips test -e /opt/$line;then
                        echo -e "\033[32m探测到 172.31.69.$ips 存在包 ：$line ，不存在则跳过..\033[0m"
                        echo "在远程服务器创建备份文件夹，若存在不进行操作.."
                        ansible 172.31.69.$ips -m file -a "path=/opt/backup state=directory"
                        date=$(date +%Y%m%d_%H:%M:%S)
                        echo "执行备份操作 备份的文件名为：backup_jar_$date..."
                        ansible 172.31.69.$ips -m shell -a "cp -a /opt/$line /opt/backup/backup_jar_$date"
                        echo "备份完成"
                        echo "正在执行更新操作..."
                        ansible 172.31.69.$ips -m shell -a "rm -rf /opt/$line"
                        scp  /opt/package/$line root@172.31.69.$ips:/opt/
			echo "执行java重启脚本..."
                        ansible 172.31.69.$ips -m shell -a "sh /media/restart/restart.sh" 
                        echo "172.31.69.$ips jar更新完成"
			echo "正在检查java启动状态.."
			
			i=0
			while (( "$i == 0" ))
			do
			port=`ansible 172.31.69.$ips -m shell -a "netstat -lntp"`
			zero=0
			[[ $port =~ "java" ]]  && zero=1
				
			if [[ $zero -eq 0 ]];then
				echo "172.31.69.$ips java未启动 正在等待..."
				i=0					
				else
				echo "172.31.69.$ips java已经启动！10秒后继续执行.."
				sleep 10s
				i=1
			fi
	
			done
		fi
	done		
	fi

done
}
