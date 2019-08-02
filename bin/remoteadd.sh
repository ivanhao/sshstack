#!/bin/bash
# Author: oldboy linux34 chentiangang ivan
# Add the authorization host with this script.

SSHSTACK="$0"
SSHSTACK="$(dirname "${SSHSTACK}")"

# 获取sshstack安装目录
SSHSTACKDIR="$(cd "${SSHSTACK}"; cd ..;pwd)"

# 加载函数库
. ${SSHSTACKDIR}/func/funcs

while true;do
  printf "\033[32m以下将添加远程用户: \n"
  read -p '输入用户> ' username
  # 加载配置文件变量
  . ${SSHSTACKDIR}/conf/sshstack.conf

  printf "\033[32m现有主机列表：\033[32m\n"
  printf "\033[33m        [IP地址]        [主机名]         [备注]\033[33m\n"
  # 在用户数据文件里过滤出已授权主机列表,输出
  awk 'NR>1{print "\t\033[33m"$1"\033[0m\t\033[33m"$2"\033[0m       \033[33m"$3"\033[0m"}' $user_info
  stty erase ^?

  read -p '授权主机> ' IP
  read -p '授权主机端口> ' ssh_port
  read -p '别名> ' alias
  if [ `grep -c  "${IP}" $user_info` -eq "1" ];then
    echo "主机已经存在!"
    break
  fi
  if id $username &> /dev/null;then
    PASS=randstr
    # 创建用户密钥
    create_key
    # 在授权主机创建用户
    add_user
    # 在本地发送密钥到授权主机
    send_key
    # 将授权主机信息写入用户数据文件
    #echo "`grep $IP $host_file`" >> $user_info
    echo "${IP}    ${alias}    修改说明" >> $user_info
    break
  elif [ `grep -c "$username" ${user_info}` -ne "1" ];then
    echo "Error: 用户在${user_info} 未找到"
    continue
  else
    echo "Error: 系统用户 ${username} 不存在."
    continue
  fi
done
