#/bin/bash
#讲jars文件转移目录并备份

function jars_bak()
{
mv /media/update/file_name/jars /media/update/file_name/bak/jars_$(date +%Y%m%d_%H:%M:%S)
}
function FG()
{
echo "--------------------------------------------------------------------------------"
}
function log_start()
{
echo ============================================================================== >> /media/update/log/log.txt
echo 未记录结束时间表示脚本在中途被退出 >> /media/update/log/log.txt
echo 脚本执行时间: $(date +%Y%m%d_%H:%M:%S) >> /media/update/log/log.txt

}

function log_stop()
{
echo 脚本结束时间: $(date +%Y%m%d_%H:%M:%S) >> /media//update/log/log.txt
echo ============================================================================== >> /media/update/log/log.txt
}
