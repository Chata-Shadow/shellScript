#/bin/env bash
#discription this scripe is used for create VUE environment
#author wuyue
#time 2019 09 14 09:48

NodeJsAdd="https://cdn.npm.taobao.org/dist/node/v12.10.0/node-v12.10.0-linux-x64.tar.xz"
pwd=""
fileName=""
InputAdd=""
pwd=`pwd`
nodeAdd=""
npmAdd=""
filePath=""
cnpmAdd=""
vueAdd=""

function createSoftL(){
    fileAddr=""
    sysAddr=""
    fileAddr=$1
    sysAddr=$2
    if [ -L $sysAddr ];then
	echo $sysAddr" is exist, now overwrite it"
	rm -rf $sysAddr
    fi
ln -s $fileAddr $sysAddr
}

#trick for check input string is empty or not !!!!!!
read -p "please input NodeJs download address or use default address" InputAdd
if [ "X${InputAdd}" != "X" ];then
    NodeJsAdd=$InputAdd
else
    InputAdd=""
fi

echo -e "\033[32m The download address is "${NodeJsAdd}"\033[0m"
wget $NodeJsAdd

#check the download success or not
if [ $? -ne 0 ]; then
    echo -e "\033[32m Please check the download address,program fail!" "\033[0m"
    exit
else
    echo -e "\033[32m Download success!" "\033[0m"
fi

#remove the string which in the left of last '/'
fileName=`echo ${NodeJsAdd##*/}`
echo $fileName
tar -xvf $fileName
chmod 777 $filePath

#create soft link
filePath=${fileName%.*}
filePath=${filePath%.*}
nodeAdd=$pwd"/"$filePath"/bin/node"
npmAdd=$pwd"/"$filePath"/bin/npm"
vueAdd=$pwd"/"$filePath"/bin/vue"

createSoftL $nodeAdd "/usr/local/bin/node"
createSoftL $npmAdd "/usr/local/bin/npm"
npm install -g cnpm --registry=https://registry.npm.taobao.org

cnpmAdd=$pwd"/"$filePath"/bin/cnpm"
createSoftL $cnpmAdd "/usr/local/bin/cnpm"

#check the cnpm install success or not
if [ $? -ne 0 ]; then 
    echo -e "\033[32m Install cnpm fail!!! program exit""\033[0m"
    exit 
else
    echo -e "\033[32m cnpm Install success!" "\033[0m"
fi

cnpm install -g vue-cli

#check the vue install success or not
if [ $? -ne 0 ]; then
    echo -e "\033[32m vue install fail!!! program exit""\033[0m"
    exit 
else
    echo -e "\033[32m vue Install success!" "\033[0m"
fi

createSoftL $vueAdd "/usr/local/bin/vue"
#set fireWall rules open 8080 port
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=8080-8085/tcp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload

#delete Unuseful file
rm -rf $filename


if [ $? -ne 0 ]; then
    echo -e "\033[32m somthing goes wrong during running time program exit""\033[0m"
    exit 
else
    echo -e "\033[32m congradulations! All install success" "\033[0m" 
fi
