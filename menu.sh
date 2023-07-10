#!/bin/bash

# Kiểm tra xem tập lệnh này được chạy với tư cách người dùng root hay không
if [[ $EUID -ne 0 ]]; then
   echo "Tập lệnh này phải được chạy với tư cách người dùng root!"
   exit 1
fi

# Hàm cài đặt AikoR
install_aikor() {
    echo "Đang cài đặt AikoR..."
    wget --no-check-certificate -O install.sh https://raw.githubusercontent.com/AikoCute-Offical/AikoR-install/vi/install.sh
    bash install.sh
    echo "Đã hoàn thành cài đặt AikoR!"
}

# Hàm cài đặt NodeID
set_nodeid() {
    read -p "Nhập số NodeID mới: " nodeID

    # Thay đổi giá trị NodeID trong file aiko.yml
    sed -i "s/NodeID: .*/NodeID: $nodeID/" "/etc/AikoR/aiko.yml"

    echo "Đã sửa NodeID thành $nodeID thành công."
}

# Bảng tuỳ chọn
options=("Cài đặt AikoR" "Cài đặt NodeID" "Thoát")
PS3="Lựa chọn của bạn: "

select opt in "${options[@]}"
do
    case $opt in
        "Cài đặt AikoR")
            install_aikor
            ;;
        "Cài đặt NodeID")
            set_nodeid
            ;;
        "Thoát")
            break
            ;;
        *) 
            echo "Lựa chọn không hợp lệ"
            ;;
    esac
done

# Thêm lệnh AikoR update vào cron job
(crontab -l 2>/dev/null; echo "0 3 * * * /usr/bin/AikoR update") | crontab -

