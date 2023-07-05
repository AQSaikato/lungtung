#!/bin/bash

# Kiểm tra xem tập lệnh này được chạy với tư cách người dùng root hay không
if [[ $EUID -ne 0 ]]; then
   echo "Tập lệnh này phải được chạy với tư cách người dùng root!"
   exit 1
fi

# Cài đặt AikoR
echo "Đang cài đặt AikoR..."
wget --no-check-certificate -O install.sh https://raw.githubusercontent.com/AikoCute-Offical/AikoR-install/vi/install.sh
bash install.sh

# Đi đến thư mục
cd /etc/AikoR

# Xoá file trong thư mục AikoR
echo "Đang xoá các file trong thư mục AikoR..."
sudo rm /etc/AikoR/aiko.yml

# Đường dẫn đến thư mục AikoR
echo "Đang tải xuống các file cần thiết..."
wget -O /etc/AikoR/aiko.yml https://raw.githubusercontent.com/quandayne/lungtung/AikoR-file/aiko.yml
wget -O /etc/AikoR/privkey.pem https://raw.githubusercontent.com/quandayne/lungtung/AikoR-file/privkey.pem
wget -O /etc/AikoR/server.pem https://raw.githubusercontent.com/quandayne/lungtung/AikoR-file/server.pem

echo "Đã hoàn thành cài đặt!"

# Nhập giá trị NodeID mới từ người dùng
read -p "Nhập giá trị NodeID mới: " nodeID

# Thay đổi giá trị NodeID trong file aiko.yml
sed -i "s/NodeID: .*/NodeID: $nodeID/" "/etc/AikoR/aiko.yml"

# Khởi động lại AikoR
AikoR restart

# In ra thông báo thành công
echo "Đã sửa NodeID thành $nodeID thành công."
