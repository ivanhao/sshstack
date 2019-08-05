### 目录说明
```sh
.
├── bin                     # 可执行文件
│   ├── addassets.sh        # 添加资产
│   ├── deluser.sh          # 删除用户脚本
│   ├── localadd.sh         # 注册用户脚本
│   ├── remoteadd.sh        # 给用户授权主机脚本
│   └── sshstack.sh         # 用户登陆后执行的shell
├── conf                    # 配置文件
│   ├── hosts               # 资产文件
│   └── sshstack.conf       # 配置文件
├── data                    # 创建用户信息与主机授权信息存放目录
│   └── example.info        
├── func                    # 函数库
│   └── funcs
└── README.md

```

### 使用
#### 1.安装
> 拉取代码到任意目录即完成安装，需要注意目录权限为755，以下存放在/opt目录下

```sh
cd /opt
git clone https://github.com/ivanhao/sshstack.git
```

#### 2.添加资产
```sh
[root@host conf]# /opt/sshstack/bin/addassets.sh
略
[root@host conf]# cat /opt/sshstack/conf/hosts
[IP地址]    [主机名]        [备注]
10.0.0.21   assets1    添加备注
```

#### 3.创建本地用户test
执行脚本，输入test
```sh
[root@oldboy sshstack]# /opt/sshstack/bin/localadd.sh
输入用户> test
INFO: 创建用户
SUCCESS.
INFO: 生成随机密码
SUCCESS.
INFO: 写入文件/opt/sshstack/data/test.info
```
> 用户创建好后，用户信息保存在/opt/sshstack/data/test.info文件


#### 4.授权主机
```sh
[root@oldboy sshstack]# /opt/sshstack/bin/remoteadd.sh
输入用户> test
授权主机> 10.0.0.21
INFO: 生成本地密钥
SUCCESS.
INFO: 创建远端用户
SUCCESS.
INFO: 发送公钥到远程主机
SUCCESS.
INFO: 修改权限
SUCCESS.
```
> 授权主机后，信息同样保存在/opt/sshstack/data/test.info文件

#### 5.查看用户信息
刚创建的用户信息保存在data目录下
```sh
[root@oldboy data]# cat /opt/sshstack/data/test.info
2018-02-02:14:46:24  用户名 test  
10.0.0.21   assets1    添加备注
```


#### 6.用户登陆
ssh命令用test用户连接上主机后：
```sh
主机列表：
        [IP地址]        [主机名]         [备注]
        10.0.0.21       assets1    添加备注

改密：password
退出：exit
清屏：clear
提示：输入主机名或IP地址连接
当前用户：test
选择主机 >
```
> 可以通过输入password修改密码，输入主机名或IP地址即可登陆到对应的授权主机。
