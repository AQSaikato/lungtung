#!/bin/bash

rm -rf $0

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)

# check root
if [ $EUID -ne 0 ]; then
   echo -e "${red}Lỗi: ${plain}Tập lệnh này phải được chạy với quyền người dùng root!\n"
   exit 1
fi

# check os
if [ -f /etc/redhat-release ]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
else
    echo -e "${red}Không phát hiện phiên bản hệ điều hành, vui lòng liên hệ tác giả tập lệnh!${plain}\n"
    exit 1
fi

arch=$(arch)

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
  arch="64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
  arch="arm64-v8a"
else
  arch="64"
  echo -e "${red}Không phát hiện kiến trúc hệ thống, sử dụng kiến trúc mặc định: ${arch}${plain}"
fi

echo "Kiến trúc hệ thống: ${arch}"

if [ "$(getconf WORD_BIT)" != '32' ] && [ "$(getconf LONG_BIT)" != '64' ]; then
    echo "Phần mềm này không hỗ trợ hệ thống 32-bit (x86), vui lòng sử dụng hệ thống 64-bit (x86_64), nếu phát hiện sai, vui lòng liên hệ tác giả"
    exit 2
fi

os_version=""

# phiên bản hệ điều hành
if [[ -f /etc/os-release ]]; then
    os_version=$(awk -F'[= ."]' '/VERSION_ID/{print $3}' /etc/os-release)
fi
if [[ -z "$os_version" && -f /etc/lsb-release ]]; then
    os_version=$(awk -F'[= ."]+' '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release)
fi

if [[ x"${release}" == x"centos" ]]; then
    if [[ ${os_version} -le 6 ]]; then
        echo -e "${red}Vui lòng sử dụng CentOS 7 trở lên!${plain}\n"
        exit 1
    fi
elif [[ x"${release}" == x"ubuntu" ]]; then
    if [[ ${os_version} -lt 16 ]]; then
        echo -e "${red}Vui lòng sử dụng Ubuntu 16 trở lên!${plain}\n"
        exit 1
    fi
elif [[ x"${release}" == x"debian" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
        echo -e "${red}Vui lòng sử dụng Debian 8 trở lên!${plain}\n"
        exit 1
    fi
fi

install_base() {
    if [[ x"${release}" == x"centos" ]]; then
        yum install epel-release -y
        yum install wget curl unzip tar crontabs socat -y
    else
        apt update -y
        apt install wget curl unzip tar cron socat -y
    fi
}

# 0: running, 1: not running, 2: not installed
check_status() {
    if [[ ! -f /etc/systemd/system/AikoR.service ]]; then
        return 2
    fi
    temp=$(systemctl status AikoR | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
    if [[ x"${temp}" == x"running" ]]; then
        return 0
    else
        return 1
    fi
}

install_acme() {
    curl https://raw.githubusercontent.com/AikoCute-Offical/AikoR-Install/master/file/acme.sh | sh
}

install_AikoR() {
    if [[ -e /usr/local/AikoR/ ]]; then
        rm /usr/local/AikoR/ -rf
    fi

    mkdir /usr/local/AikoR/ -p
    cd /usr/local/AikoR/
    
    if [ $# == 0 ]; then
        last_version=$(curl -Ls "https://api.github.com/repos/AikoCute-Offical/AikoR/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        if [[ ! -n "$last_version" ]]; then
            echo -e "${red}Không phát hiện phiên bản AikoR, có thể đã vượt quá giới hạn của Github API, vui lòng thử lại sau hoặc chỉ định cài đặt phiên bản AikoR theo cách thủ công${plain}"
            exit 1
        fi
        echo -e "Đã phát hiện phiên bản mới nhất của AikoR: ${last_version}, bắt đầu quá trình cài đặt"
        wget -N --no-check-certificate -O /usr/local/AikoR/AikoR-linux.zip https://github.com/AikoCute-Offical/AikoR/releases/download/${last_version}/AikoR-linux-${arch}.zip
        if [[ $? -ne 0 ]]; then
            echo -e "${red}Không tải xuống được AikoR, vui lòng đảm bảo máy chủ của bạn có thể tải xuống tệp từ GitHub${plain}"
            exit 1
        fi
    else
        last_version=$1
        url="https://github.com/AikoCute-Offical/AikoR/releases/download/${last_version}/AikoR-linux-${arch}.zip"
        echo -e "Bắt đầu cài đặt AikoR v$1"
        wget -N --no-check-certificate -O /usr/local/AikoR/AikoR-linux.zip ${url}
        if [[ $? -ne 0 ]]; then
            echo -e "${red}Không tải xuống được AikoR v$1, vui lòng đảm bảo rằng phiên bản này tồn tại${plain}"
            exit 1
        fi
    fi

    unzip AikoR-linux.zip
    rm AikoR-linux.zip -f
    chmod +x AikoR
    mkdir /etc/AikoR/ -p
    rm /etc/systemd/system/AikoR.service -f
    file="https://raw.githubusercontent.com/AikoCute-Offical/AikoR-install/dev/AikoR.service"
    wget -N --no-check-certificate -O /etc/systemd/system/AikoR.service ${file}
    #cp -f AikoR.service /etc/systemd/system/
    systemctl daemon-reload
    systemctl stop AikoR
    systemctl enable AikoR
    echo -e "${green}Hoàn tất quá trình cài đặt AikoR ${last_version}${plain}, đã cấu hình để khởi động tự động"
    cp geoip.dat /etc/AikoR/
    cp geosite.dat /etc/AikoR/ 

    if [[ ! -f /etc/AikoR/aiko.yml ]]; then
        cp aiko.yml /etc/AikoR/
        echo -e ""
        echo -e "Cài đặt mới, vui lòng xem hướng dẫn trước đó: https://github.com/AikoCute-Offical/AikoR, và cấu hình theo yêu cầu"
    else
        systemctl start AikoR
        sleep 2
        check_status
        echo -e ""
        if [[ $? == 0 ]]; then
            echo -e "${green}Khởi động AikoR thành công${plain}"
        else
            echo -e "${red}Có thể AikoR không khởi động, vui lòng kiểm tra thông tin nhật ký AikoR sau khi kiểm tra, nếu không thể khởi động, có thể đã thay đổi định dạng cấu hình, vui lòng kiểm tra wiki: https://github.com/AikoCute-Offical/AikoR${plain}"
        fi
    fi

    if [[ ! -f /etc/AikoR/dns.json ]]; then
        cp dns.json /etc/AikoR/
    fi
    if [[ ! -f /etc/AikoR/route.json ]]; then
        cp route.json /etc/AikoR/
    fi
    if [[ ! -f /etc/AikoR/custom_outbound.json ]]; then
        cp custom_outbound.json /etc/AikoR/
    fi
    if [[ ! -f /etc/AikoR/AikoBlock ]]; then
        cp AikoBlock /etc/AikoR/
    fi
    curl -o /usr/bin/AikoR -Ls https://raw.githubusercontent.com/AikoCute-Offical/AikoR-install/dev/AikoR.sh
    chmod +x /usr/bin/AikoR
    echo -e "${green}AikoR đã cài đặt thành công!${plain}"
}

install_AikoR

