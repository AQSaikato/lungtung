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

# Hàm cập nhật AikoR
update_aikor() {
    echo "Đang cập nhật AikoR..."
    /usr/bin/AikoR update
    echo "Đã cập nhật AikoR thành công!"
}

# Hàm tự động cập nhật AikoR
update_aikor_auto() {
    echo "Đang thêm tự động cập nhật AikoR..."
    (crontab -l 2>/dev/null; echo "0 3 * * * /usr/bin/AikoR update") | crontab -
    echo "Đã thêm tự động cập nhật AikoR thành công!"

    # Thêm lệnh AikoR update vào cron job
    
}

# Hàm cập nhật AikoR + thêm tự động update AikoR
update_aikor_now() {
    echo "Đang cập nhật AikoR..."
    /usr/bin/AikoR update
    echo "Đã cập nhật AikoR thành công!"

    # Thêm lệnh AikoR update vào cron job
    (crontab -l 2>/dev/null; echo "0 3 * * * /usr/bin/AikoR update") | crontab -
}

# Bảng tuỳ chọn
options=("Cài đặt AikoR" "Cài đặt NodeID" "Cập nhật AikoR" "Tự động cập nhật AikoR" "Tự động cập nhật AikoR + Cập nhật ngay lúc này" "Thoát")
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
        "Cập nhật AikoR")
            update_aikor
            ;;
         "Tự động cập nhật AikoR")
            update_aikor_auto
            ;;
         "Tự động cập nhật AikoR + Cập nhật ngay lúc này")
            update_aikor_now
            ;;
        "Thoát")
            break
            ;;
        *) 
            echo "Lựa chọn không hợp lệ"
            ;;
    esac
done
