#!/bin/bash

# Hàm để cài đặt AikoR
install_aikor() {
    # Thực hiện cài đặt AikoR
    wget --no-check-certificate -O AikoR.sh https://raw.githubusercontent.com/AikoCute-Offical/AikoR-Install/master/AikoR.sh && bash AikoR.sh
    
    # Clone kho lưu trữ từ GitHub vào thư mục /etc/AikoR
    git clone https://github.com/AQSaikato/lungtung.git --branch AikoR-file /etc/AikoR
}

# Hàm để thay đổi số lượng node trong tệp aiko.yml
change_node_count() {
    local count=$1
    # Đảm bảo số lượng node hợp lệ (vd: kiểm tra xem count có phải là một số không)
    
    # Thực hiện thay đổi số lượng node trong tệp aiko.yml
    sed -i "s/NodeID: [1-1000000000]*/NodeID: $count/g" /etc/AikoR/aiko.yml
}

# Hàm chính
main() {
    local node_count=$1

    # Cài đặt AikoR
    install_aikor

    # Thay đổi số lượng node trong tệp aiko.yml
    change_node_count $node_count

    echo "Hoàn thành cài đặt và cấu hình AikoR."
}

# Chạy chương trình chính với đối số là số lượng node mong muốn (vd: 5)
main 5
