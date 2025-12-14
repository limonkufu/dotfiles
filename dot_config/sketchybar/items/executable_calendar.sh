#!/usr/bin/env sh

sketchybar --add item     calendar right               \
           --set calendar icon=cal                     \
                          icon.color=$BLACK            \
                          icon.font="$FONT:Black:10.0" \
                          icon.padding_left=5          \
                          icon.padding_right=5         \
                          icon.drawing=off              \
                          icon.y_offset=8              \
                          label.color=$BLACK           \
                          label.padding_left=5       \
                          label.padding_right=5        \
                          background.color=0xffb8c0e0  \
                          background.height=26         \
                          background.corner_radius=11



                        #   icon.color=$BLACK            \
                        #   icon.font="$FONT:Black:10.0" \
                        #   icon.padding_left=5          \
                        #   icon.padding_right=5         \
                        #   icon.drawing=off              \
                        #   icon.y_offset=8              \
                        #   label.color=$BLACK           \
                        #   label.y_offset=-8           \
                        #   label.padding_left=-40       \
                        #   label.padding_right=5        \
                        #   background.color=0xffb8c0e0  \
                        #   background.height=45         \
                        #   background.corner_radius=11  \
                        #   script="/Users/u.yilmaz/.config/sketchybar/plugins/calendar.sh"