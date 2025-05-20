#!/bin/bash

# 定義 sink 名稱
G533="alsa_output.usb-Logitech_G533_Gaming_Headset-00.analog-stereo"
SOUNDBAR="alsa_output.usb-Dell_DELL_Slim_Soundbar_SB521A_SB521-A-00.analog-stereo"

# 通知 ID 檔案（用來記住上次的通知 ID）
NOTIFY_ID_FILE="/tmp/audio_output_notify_id"

# 取得目前 default sink
CURRENT=$(pactl get-default-sink)

# 判斷切換目標
if [[ "$CURRENT" == "$G533" ]]; then
    TARGET="$SOUNDBAR"
    MSG="🔈 切換到 Dell Soundbar"
elif [[ "$CURRENT" == "$SOUNDBAR" ]]; then
    TARGET="$G533"
    MSG="🎧 切換到 Logitech G533"
else
    TARGET="$G533"
    MSG="⚠️ 未知裝置，預設切換到 G533"
fi

# 切換 sink
pactl set-default-sink "$TARGET"

# 移動現有音訊流
for INPUT in $(pactl list short sink-inputs | cut -f1); do
    pactl move-sink-input "$INPUT" "$TARGET"
done

# 發送 dunstify 通知，支援更新
if command -v dunstify >/dev/null; then
    if [[ -f "$NOTIFY_ID_FILE" ]]; then
        PREV_ID=$(<"$NOTIFY_ID_FILE")
    else
        PREV_ID=0
    fi

    NEW_ID=$(dunstify -p -r "$PREV_ID" -u normal "音訊輸出切換" "$MSG")
    echo "$NEW_ID" > "$NOTIFY_ID_FILE"
else
    notify-send "音訊輸出切換" "$MSG"
fi

