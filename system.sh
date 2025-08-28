#!/bin/bash
# sistem_menu.sh

while true; do
    clear
    echo "============================"
    echo "     Sistem Yönetim Menüsü   "
    echo "============================"
    echo "1) Giriş zamanımı göster"
    echo "2) Belirli bir dizindeki dosya sayısını göster"
    echo "3) İnternet bağlantısını kontrol et"
    echo "4) Disk kullanımını kontrol et"
    echo "5) RAM kullanımını kontrol et"
    echo "6) Nginx servis durumunu kontrol et"
    echo "7) Nginx'i yeniden başlat"
    echo "8) SSH giriş hatalarını loglardan göster"
    echo "9) UFW kurallarını listele"
    echo "10) UFW'ye yeni kural ekle"
    echo "11) Çıkış"
    echo "============================"
    read -p "Bir seçim yapınız (1-11): " secim

    case $secim in
        1)
            echo "Kullanıcı: $USER"
            echo "Giriş zamanı: $(who | grep $USER | awk '{print $3, $4}')"
            ;;
        2)
            read -p "Hangi dizini kontrol edelim?: " dizin
            if [ -d "$dizin" ]; then
                SAYI=$(ls -1 "$dizin" | wc -l)
                echo "$dizin dizininde toplam $SAYI dosya var."
            else
                echo "Hata: $dizin dizini bulunamadı."
            fi
            ;;
        3)
            ping -c 2 8.8.8.8 > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "İnternet bağlantısı aktif "
            else
                echo "İnternet bağlantısı yok "
            fi
            ;;
        4)
            KULLANIM=$(df -h /home | awk 'NR==2 {print $5}')
            echo "/home dizini disk kullanımı: $KULLANIM"
            ;;
        5)
            KULLANIM=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2*100}')
            echo "RAM kullanımı: %$KULLANIM"
            ;;
        6)
            systemctl status nginx --no-pager | head -n 5
            ;;
        7)
            sudo systemctl restart nginx
            echo "Nginx yeniden başlatıldı "
            ;;
        8)
            echo "Son 10 SSH hata kaydı:"
            sudo grep "Failed password" /var/log/auth.log | tail -n 10
            ;;
        9)
            echo "Mevcut UFW kuralları:"
            sudo ufw status numbered
            ;;
        10)
            read -p "İzin vermek istediğin portu gir (ör: 22, 80, 443): " port
            sudo ufw allow $port/tcp
            echo "$port numaralı port açıldı "
            ;;
        11)
            echo "Çıkılıyor..."
            break
            ;;
        *)
            echo "Geçersiz seçim!"
            ;;
    esac

    echo ""
    read -p "Devam etmek için Enter'a basın..."
done
