function all_bak()
{
echo "备份服务器清单："
tail -n 19 /etc/ansible/hosts
sleep 3s
echo "即将把需要更新的文件进行批量备份至各服务器..."
read -p "输入任意字符继续：" Confirmx
date=$(date +%Y%m%d_%H:%M:%S)
echo "创建备份文件夹："
ansible update -m file -a "path=/opt/sh_backup state=directory"
ansible app -m file -a "path=/opt/app/sh_backup state=directory"
echo "备份JAR..."
FG
ansible update -m shell -a "cp -a /opt/*.jar /opt/sh_backup/backup_jar_$date"
FG

sleep 3s
echo "备份dist"

FG
ansible  app -m shell -a "cp -a /opt/app/dist /opt/app/sh_backup/backup_dist_$date"
FG
}
