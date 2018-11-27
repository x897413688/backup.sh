#/bin/bash
. ./include/log.sh
. ./include/up.sh
. ./include/jar_service.sh
. ./include/all_bak.sh

clear
printf "
\033[31m#########################################################################################################
# 执行此脚本前，请仔细阅读此说明							   		#	
# 此脚本用于更新商城java程序的代码包，且无法通过此脚本进行恢复 						#
# 备份文件在各服务器/opt/sh_backup/目录下，名称为backup_jar_时间					#
# 脚本执行后会有两份备份文件，为防止脚本过程中出现错误，以后会减少至一个					#
# 更新脚本同时使用Ansible，必须将ssh-id传输到需要更新的服务器，并记录在/etc/ansible/hosts 文件中	#
# 更新前请务必确认jar包可正常使用且更新服务器在已知集群内						#
# 请勿删除各服务器上的重启脚本，位置：/media/restart/restart.sh						#
# 脚本在centos6.8中进行测试并可正常使用             							#
# 脚本最后更新时间 2018 11.23 				                                       		#
#########################################################################################################
\033[0m
"
read -p "请确认是否执行(Y)：" Confirm
log_start
if [ $Confirm != "Y" ]
then
echo "输入了其他字符，程序终止"
exit
else
echo -e "\033[34m脚本正在初始化...\033[0m"
rm -rf /media/update/file_name/jars
sleep 2s

all_bak


echo -e "\033[33m正在读取本地/opt/package目录下文件...\033[0m"
cd /opt/package/
for file in $(ls *)
do
    echo $file >> /media/update/file_name/jars
done
echo -e "\033[33m读取完成\033[0m"
FG
read -p "即将更新service服务器，ctrl+c退出程序，回车则继续：" Confirmc

echo -e "\033[33m
首先更新两台service服务器，确定第一台重启成功后执行另外一台。
\033[0m"
sleep 1s
service
read -p "service更新完毕，即将更新集群1线，ctrl+c退出程序，回车则继续" Confirm0


for ip in {118..124}
do
	if [[ $ip -lt 129 ]];then
	set=1
	up
	elif [[ $ip -ge 129 ]];then
	set=2 
	up

	fi

done

read -p "确认是否在2线进行更新，ctrl+c退出程序,回车则继续：" Confirm1
for ip in {129..136}
do
        if [[ $ip -lt 129 ]];then
        set=1
        up
        elif [[ $ip -ge 129 ]];then
        set=2 
        up

        fi

done


#mv /media/update/file_name/jars /media/update/file_name/bak/jars_$(date +%Y%m%d_%H:%M:%S)
fi


jars_bak
log_stop
# cat jars | while read jar;do
#        if 
#        ssh  172.31.69.118 test -e /opt/$jar;
#        then echo “ $ip yes”
#        else echo " $ip no have this file"
#        fi
#        done
