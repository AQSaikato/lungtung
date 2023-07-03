#!/bin/bash

# Kiểm tra xem tập lệnh được chạy với quyền root hay không
if [[ $EUID -ne 0 ]]; then
    echo "Tập lệnh này phải được chạy với quyền root!"
    exit 1
fi

# Lệnh cài đặt AikoR
wget --no-check-certificate -O AikoR.sh https://raw.githubusercontent.com/AikoCute-Offical/AikoR-install/dev/install.sh && bash AikoR.sh

# Kiểm tra xem việc cài đặt AikoR thành công hay không
if [ $? -eq 0 ]; then
    echo "Cài đặt AikoR thành công."
else
    echo "Lỗi xảy ra khi cài đặt AikoR."
    exit 1
fi

# Tải xuống tệp từ nhánh AikoR-file trên GitHub và lưu vào thư mục /etc/AikoR
wget -O /etc/AikoR/aiko.yml https://raw.githubusercontent.com/AQSaikato/lungtung/AikoR-file/aiko.yml
wget -O /etc/AikoR/aiko.yml https://raw.githubusercontent.com/AQSaikato/lungtung/AikoR-file/privkey.pem
wget -O /etc/AikoR/aiko.yml https://raw.githubusercontent.com/AQSaikato/lungtung/AikoR-file/server.pem

# Kiểm tra xem việc tải xuống thành công hay không
if [ $? -eq 0 ]; then
    echo "Tải xuống tệp thành công."
else
    echo "Lỗi xảy ra khi tải xuống tệp."
    exit 1
fi

# Nhập số NodeID mới từ người dùng
echo "Nhập số NodeID mới:"
read newNodeID

# Đường dẫn đến tệp aiko.yml
aikoConfigFile="/etc/AikoR/aiko.yml"

# Thay thế giá trị NodeID trong tệp aiko.yml
sed -i "s/NodeID: [0-9]*/NodeID: $newNodeID/" "$aikoConfigFile"

# In ra thông báo thành công
echo "Đã cập nhật giá trị NodeID trong tệp aiko.yml thành $newNodeID."
