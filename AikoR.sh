#!/bin/bash

# Kiểm tra xem tập lệnh này được chạy với tư cách người dùng root hay không
if [[ $EUID -ne 0 ]]; then
   printf "Chạy tập lệnh này cần quyền root!\n"
   exit 1
fi

# Cài đặt AikoR
printf "Đang cài đặt AikoR...\n"
wget --no-check-certificate -O install.sh https://raw.githubusercontent.com/AQSaikato/lungtung/AikoR/install.sh
bash install.sh

# Đi đến thư mục
cd /etc/AikoR

# Xoá file trong thư mục AikoR
printf "Đang xoá các file trong thư mục AikoR...\n"
sudo rm /etc/AikoR/aiko.yml

# Đường dẫn đến thư mục AikoR
printf "Đang tải xuống các file cần thiết...\n"
wget -O /etc/AikoR/aiko.yml https://raw.githubusercontent.com/AQSaikato/lungtung/AikoR-file/aiko.yml
wget -O /etc/AikoR/privkey.pem https://raw.githubusercontent.com/AQSaikato/lungtung/AikoR-file/privkey.pem
wget -O /etc/AikoR/server.pem https://raw.githubusercontent.com/AQSaikato/lungtung/AikoR-file/server.pem

printf "Đã hoàn thành cài đặt!\n"


# Nhập giá trị NodeID mới từ người dùng
read -p "Nhập giá trị NodeID mới: " nodeID

# Thay đổi giá trị NodeID trong file aiko.yml
sed -i "s/NodeID: .*/NodeID: $nodeID/" "/etc/AikoR/aiko.yml"

# Khởi động lại AikoR
AikoR restart

# In ra thông báo thành công
echo "Đã sửa NodeID thành $nodeID thành công."