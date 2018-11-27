#/bin/bash
function up(){
        FG
        echo "正在集群$set线 172.31.69.$ip 执行更新操作,未检测到需要更新的包则跳过："
        if [[ $ip -eq 118 || $ip -eq 131 ]];then
               echo "跳过172.31.69.$ip service服务器"
        else            
        for line in `cat /media/update/file_name/jars`;do
                if ssh  172.31.69.$ip test -e /opt/$line;then
                        echo -e "\033[32m探测到 172.31.69.$ip 存在包 ：$line \033[0m"
                        echo "在远程服务器创建备份文件夹，已存在则不进行操作.."
                        ansible 172.31.69.$ip -m file -a "path=/opt/sh_backup state=directory"
                        date=$(date +%Y%m%d_%H:%M:%S)
                        echo "执行备份操作 备份的文件名为：backup_jar_$date..."
                        ansible 172.31.69.$ip -m shell -a "cp -a /opt/$line /opt/sh_backup/backup_jar_$date"
                        echo "备份完成"
                        echo "正在执行更新操作..."
                        ansible 172.31.69.$ip -m shell -a "rm -rf /opt/$line"
                        scp  /opt/package/$line root@172.31.69.$ip:/opt/ 
			echo "执行java重启脚本.."
                        ansible 172.31.69.$ip -m shell -a "sh /media/restart/restart.sh" 
                        echo "172.31.69.$ip jar更新完成"
		#else
		#echo "未检测到 172.31.69.$ip 上存在需要更新的jar包"
		fi
            
        done
         
         for line in `cat /media/update/file_name/jars`;do
                if ssh  172.31.69.$ip test -e /opt/app/$line;then
                        
                        echo -e "\033[32m探测到 172.31.69.$ip 存在文件 ：$line  ，将执行更新zip的操作\033[0m"
                        echo "执行备份操作 备份的文件名为：backup_dist_$date..."
                        ansible 172.31.69.$ip -m shell -a "cp -a /opt/app/dist /opt/app/sh_backup/backup_dist_$date"
                        echo "备份完成"
                        date=$(date +%Y%m%d_%H:%M:%S)
                        echo "在远程服务器创建upd传递文件夹，已存在则不进行操作.."
                        ansible 172.31.69.$ip -m file -a "path=/opt/app/upd state=directory"
                        echo "正在执行更新操作..."
                        scp  /opt/package/$line root@172.31.69.$ip:/opt/app/upd/
                        ansible 172.31.69.$ip -m shell -a "unzip -o -d /opt/app/  /opt/app/upd/dist.zip"
                        ansible 172.31.69.$ip -m file -a "path=/opt/app/upd/dist.zip state=absent"
      		        echo "172.31.69.$ip dist更新完成"
		#else
                #echo "未检测到 172.31.69.$ip 上存在需要更新的dist"
		fi
        done
        
        fi
        FG
}

