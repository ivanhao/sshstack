### 二、目录说明
```sh
.
├── bin                     # 可执行文件
│   ├── deluser.sh          # 删除用户脚本
│   ├── localadd.sh         # 注册用户脚本
│   ├── remoteadd.sh        # 给用户授权主机脚本
│   └── sshstack.sh         # 用户登陆后执行的shell
├── conf                    # 配置文件
│   ├── hosts               # 配置已有的资产
│   └── sshstack.conf       # 配置文件
├── data                    # 创建用户信息与主机授权信息存放目录
│   └── oldboy.info        
├── func                    # 函数库
│   └── funcs
└── README.md

4 directories, 9 files
```

### 三、最佳实践
#### 1.安装
> 拉取代码到任意目录即完成安装，需要注意目录权限为755，以下存放在/opt目录下

```sh
cd /opt
git clone https://github.com/sshstack/sshstack.git
```

#### 2.添加资产
> 将被管理主机填入/opt/sshstack/conf/hosts即可,这里我们有三台oldboy的主机。
```sh
[root@oldboy conf]# cat /opt/sshstack/conf/hosts
[IP地址]    [主机名]        [备注]
10.0.0.21   oldboy-web01    老男孩教育官网接口
10.0.0.22   oldboy-web02    老男孩教育官网h5页面
10.0.0.23   oldboy-web03    老男孩教育官网后台
```

#### 3.创建本地用户oldboy
执行脚本，输入oldboy
```sh
[root@oldboy sshstack]# /opt/sshstack/bin/localadd.sh
输入用户> oldboy
INFO: 创建用户
SUCCESS.
INFO: 生成随机密码
SUCCESS.
INFO: 写入文件/opt/sshstack/data/oldboy.info
```
> 用户创建好后，用户信息保存在/opt/sshstack/data/wanggang.info文件


#### 4.授权主机
这里将授权oldboy用户可以登陆oldboy-web01、oldboy-web02、oldboy-web03这三台主机
```sh
[root@oldboy sshstack]# /opt/sshstack/bin/remoteadd.sh
输入用户> oldboy
授权主机> 10.0.0.21
INFO: 生成本地密钥
SUCCESS.
INFO: 创建远端用户
SUCCESS.
INFO: 发送公钥到远程主机
SUCCESS.
INFO: 修改权限
SUCCESS.
[root@oldboy sshstack]# /opt/sshstack/bin/remoteadd.sh
输入用户> oldboy
授权主机> 10.0.0.22
INFO: 生成本地密钥
SUCCESS.
INFO: 创建远端用户
SUCCESS.
INFO: 发送公钥到远程主机
SUCCESS.
INFO: 修改权限
SUCCESS.
[root@oldboy sshstack]# /opt/sshstack/bin/remoteadd.sh
输入用户> oldboy
授权主机> 10.0.0.23
INFO: 生成本地密钥
SUCCESS.
INFO: 创建远端用户
SUCCESS.
INFO: 发送公钥到远程主机
SUCCESS.
INFO: 修改权限
SUCCESS.
```
> 授权主机后，信息同样保存在/opt/sshstack/data/oldboy.info文件

#### 5.查看用户信息
刚创建的用户信息保存在data目录下
```sh
[root@oldboy data]# cat /opt/sshstack/data/oldboy.info
2018-02-02:14:46:24  用户名 oldboy  密码 2fe579e7
10.0.0.21   oldboy-web01    老男孩教育官网接口
10.0.0.22   oldboy-web02    老男孩教育官网h5页面
10.0.0.23   oldboy-web03    老男孩教育官网后台
```


#### 6.用户登陆
因为oldboy用户在oldboy主机上已经创建，我们只需要在自已电脑执行ssh命令即可连接，我这里以mac为例：
```sh
Mac:~ chentiangang$ ssh -p25535 oldboy@oldboy
oldboy@oldboy's password:
Last failed login: Fri Feb  2 10:28:44 CST 2018 from 106.37.109.202 on ssh:notty
There were 2 failed login attempts since the last successful login.

Welcome to Alibaba Cloud Elastic Compute Service !
主机列表：
        [IP地址]        [主机名]         [备注]
        10.0.0.21     oldboy-web01    老男孩教育官网接口
        10.0.0.22     oldboy-web02    老男孩教育官网h5页面
        10.0.0.23     oldboy-web03    老男孩教育官网后台

改密：password
退出：exit
清屏：clear
提示：输入主机名或IP地址连接
oldboy 选择主机 >
```
> 用户登陆后即要看到已授权的主机，可以通过输入password修改密码，输入主机名或IP地址即可登陆到对应的授权主机。
