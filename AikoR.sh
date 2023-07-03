#!/bin/bash

# Kiểm tra xem tập lệnh này được chạy với tư cách người dùng root hay không
if [[ $EUID -ne 0 ]]; then
   printf "Tập lệnh này phải được chạy với tư cách người dùng root!\n"
   exit 1
fi

# Cài đặt AikoR
wget --no-check-certificate -O install.sh https://raw.githubusercontent.com/AQSaikato/lungtung/AikoR/install.sh
bash install.sh

# Đường dẫn đến thư mục AikoR
wget -O /etc/AikoR/aiko.yml https://raw.githubusercontent.com/AQSaikato/lungtung/AikoR-file/aiko.yml
wget -O /etc/AikoR/aiko.yml https://raw.githubusercontent.com/AQSaikato/lungtung/AikoR-file/privkey.pem
wget -O /etc/AikoR/aiko.yml https://raw.githubusercontent.com/AQSaikato/lungtung/AikoR-file/server.pem

# Nhập giá trị NodeID mới từ người dùng
read -p "Nhập giá trị NodeID mới: " nodeID

# Thay đổi giá trị NodeID trong file aiko.yml
sed -i "s/NodeID: .*/NodeID: $nodeID/" "$aikoDirectory/aiko.yml"

# In ra thông báo thành công
echo "Đã cài đặt AikoR, ném file từ repository GitHub vào thư mục /etc/AikoR và sửa đổi giá trị NodeID thành $nodeID trong file aiko.yml."
