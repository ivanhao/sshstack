#!/bin/bash
# Author: ivan
# Add the authorization host with this script.

SSHSTACK="$0"
SSHSTACK="$(dirname "${SSHSTACK}")"

# 获取sshstack安装目录
SSHSTACKDIR="$(cd "${SSHSTACK}"; cd ..;pwd)"

username=`whoami`
# 加载函数库
. ${SSHSTACKDIR}/func/funcs

# 加载配置文件变量
. ${SSHSTACKDIR}/conf/sshstack.conf

reading(){
    printf "\033[32m现有主机列表：\033[32m\n"
    #printf "\033[33m        [IP地址]        [主机名]         [备注]\033[33m\n"
    # 在用户数据文件里过滤出已授权主机列表,输出
    awk 'NR>1{print "\t\033[33m"$1"\033[0m\t\033[33m"$2"\033[0m       \033[33m"$3"\033[0m"}' $host_file

    printf "\033[32m退出：\033[0m\033[33mexit\033[0m\n"
    printf "\033[32m清屏：\033[0m\033[33mclear\033[0m\n"
    stty erase ^?

    while true;do
        read -p '授权新主机> ' IP
        if [ `grep -c  "${IP}" $host_file` -eq "1" ];then
            echo "主机已经存在!"
            break
        else
            case $IP in
            clear) clear ; reading ;;
            exit) echo "退出操作" && exit ;;
            quit) echo "退出操作" && exit ;;
            esac
        fi
        read -p '授权主机端口(默认22)> ' ssh_port
        if [ ! ${ssh_port} ];then
            ssh_port=22
        fi
        read -p '别名> ' alias
        if id $username &> /dev/null;then
            # 创建用户密钥
            create_key
            # 在授权主机创建用户
            #add_user
            # 在本地发送密钥到授权主机
            send_key
            # 将授权主机信息写入用户数据文件
            #echo "`grep $IP $host_file`" >> $user_info
            echo "${IP}    ${alias}       修改说明" >> $host_file
            cp $host_file $user_info
        elif [ `grep -c "$username" ${user_info}` -ne "1" ];then
            echo "Error: 用户在${user_info} 未找到"
            continue
        else
            echo "Error: 系统用户 ${username} 不存在."
            continue
        fi
    done
}
reading
