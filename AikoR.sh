#!/bin/bash

# Kiểm tra xem tập lệnh này được chạy với tư cách người dùng root hay không
if [[ $EUID -ne 0 ]]; then
   printf "Tập lệnh này phải được chạy với tư cách người dùng root!\n"
   exit 1
fi

# Cài đặt AikoR
wget --no-check-certificate -O install.sh https://raw.githubusercontent.com/AikoCute-Offical/AikoR-install/dev/install.sh
bash install.sh

# Đường dẫn đến thư mục AikoR
aikoDirectory="/etc/AikoR"

# Link của repository GitHub
gitRepo="https://github.com/AQSaikato/lungtung/tree/AikoR-file"

# Clone repository GitHub vào thư mục AikoR
git clone "$gitRepo" "$aikoDirectory"

# Nhập giá trị NodeID mới từ người dùng
read -p "Nhập giá trị NodeID mới: " nodeID

# Thay đổi giá trị NodeID trong file aiko.yml
sed -i "s/NodeID: .*/NodeID: $nodeID/" "$aikoDirectory/aiko.yml"

# In ra thông báo thành công
echo "Đã cài đặt AikoR, ném file từ repository GitHub vào thư mục /etc/AikoR và sửa đổi giá trị NodeID thành $nodeID trong file aiko.yml."
