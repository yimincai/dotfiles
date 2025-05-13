## not working fine
# #!/bin/bash
#
# direction="$1"
#
# # 获取当前窗口信息
# current_window=$(yabai -m query --windows --window)
# current_id=$(echo "$current_window" | jq '.id')
#
# # 尝试在当前显示器上切换焦点
# yabai -m window --focus "$direction"
# sleep 0.1
#
# # 检查焦点是否已更改
# new_window=$(yabai -m query --windows --window)
# new_id=$(echo "$new_window" | jq '.id')
#
# if [ "$current_id" -eq "$new_id" ]; then
#     # 焦点未更改，尝试在相邻显示器上切换焦点
#     case "$direction" in
#     west)
#         yabai -m display --focus west
#         ;;
#     east)
#         yabai -m display --focus east
#         ;;
#     north)
#         yabai -m display --focus north
#         ;;
#     south)
#         yabai -m display --focus south
#         ;;
#     esac
#     sleep 0.1
#     yabai -m window --focus "$direction"
# fi

# #!/bin/bash
#
# # Get the ID of the currently focused window
# current_window=$(yabai -m query --windows --window | jq -r '.id')
#
# # Get the display ID of the currently focused window
# current_display=$(yabai -m query --windows --window | jq -r '.display')
#
# # Get the list of windows on the current display
# windows_on_display=$(yabai -m query --windows --display $current_display)
#
# # Count the number of windows on the current display
# window_count=$(echo "$windows_on_display" | jq length)
#
# # Determine the next window to focus
# if [ "$window_count" -gt 1 ]; then
#     # If multiple windows are on the current display, cycle through them
#     next_window=$(echo "$windows_on_display" | jq -r --arg id "$current_window" '.[] | select(.id != ($id | tonumber)) | .id' | head -n 1)
# else
#     # If only one window is on the current display, move to the next display
#     next_display=$(yabai -m query --displays | jq -r --arg id "$current_display" '.[] | select(.id != ($id | tonumber)) | .id' | head -n 1)
#     next_window=$(yabai -m query --windows --display $next_display | jq -r '.[0].id')
#     # Focus the next display
#     yabai -m display --focus $next_display
# fi
#
# # Focus the next window
# yabai -m window --focus $next_window
