#!/bin/bash

PROGRESS_FILE="progress.log"

echo "CKAD 30 Günlük Lab Başlatılıyor..."
echo "Lütfen 1-30 arası gün numarasını girin:"
read -r DAY

if [ "$DAY" -lt 1 ] || [ "$DAY" -gt 30 ]; then
    echo "Hatalı gün numarası. 1-30 arası bir sayı girin."
    exit 1
fi

DAY_FOLDER=$(printf "day%02d" "$DAY")

if [ ! -d "$DAY_FOLDER" ]; then
    echo "Gün klasörü bulunamadı: $DAY_FOLDER"
    exit 1
fi

echo ""
echo "===== Gün $DAY - $DAY_FOLDER ====="
echo ""
cat "$DAY_FOLDER/README.md"
echo ""
echo "İlgili YAML dosyaları:"
ls "$DAY_FOLDER"/*.yaml 2>/dev/null
echo ""
echo "Komut alıştırmaları için: $DAY_FOLDER/commands.sh"
echo ""
echo "Gün tamamlandığında 'Tamamladım' yazın ve enter'a basın:"
read -r COMPLETE

if [[ "$COMPLETE" == "Tamamladım" ]]; then
    echo "Gün $DAY tamamlandı." >> "$PROGRESS_FILE"
    echo "İlerleme kaydedildi."
fi
