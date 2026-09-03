#!/usr/bin/env bash
set -euo pipefail

file="src/Clash/RemoteConfig/Lainbo.ini"

sed -i 's/|isp|/|/g' "$file"
sed -i '/^exclude_remarks/a\\nruleset=✈️ 节点选择,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/CustomProxy.list\n\nruleset=💬 AI专用,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/CustomAI.list\n\nruleset=🇺🇸 美国自动,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/America.list\n\nruleset=🇺🇸 美国自动,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/GoogleAI.list\n\nruleset=🇪🇺 欧洲自动,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/Europe.list\n\nruleset=🇯🇵 日本自动,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/Japan.list\n\nruleset=🎵 RYM和其他刁钻网站,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/RYMandMore.list\n\nruleset=📚 EH专用,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/EH.list\n\nruleset=🔗 无需代理,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/CustomDirect.list' "$file"
sed -i '/^custom_proxy_group=💬 AI专用/a\custom_proxy_group=🎵 RYM和其他刁钻网站`select`[]✈️ 节点选择`[]🇸🇬 狮城自动`[]🇺🇸 美国自动`[]🇪🇺 欧洲自动`[]🇭🇰 香港自动`[]🇨🇳 台湾自动`[]🇯🇵 日本自动`.*`[]DIRECT\ncustom_proxy_group=📚 EH专用`select`[]✈️ 节点选择`[]🇸🇬 狮城自动`[]🇺🇸 美国自动`[]🇪🇺 欧洲自动`[]🇭🇰 香港自动`[]🇨🇳 台湾自动`[]🇯🇵 日本自动`.*`[]DIRECT' "$file"

awk '
    { print }
    $0 == "emoji=(?i:expire|时间|过期),🕒" {
        print "emoji=(?i:Tokyo),🇯🇵"
        print "emoji=(?i:Oregon),🇺🇸"
        print "emoji=(?i:Seoul),🇰🇷"
        print "emoji=(?i:Montreal),🇨🇦"
    }
' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"

india_re='印度([^尼]|$)|孟买|加尔各答|贾坎德'
indo_re='印尼|印度尼西亚|雅加达'

if grep -qE "$india_re" "$file"; then
    # 抽出印度行存到临时文件
    grep -E "$india_re" "$file" > /tmp/india_lines.txt
    # 从原文件删除
    grep -vE "$india_re" "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
    # 插到第一个印尼行之后（逐行原样输出，无转义问题）
    if grep -qE "$indo_re" "$file"; then
        awk -v f=/tmp/india_lines.txt '
            !done && /印尼|印度尼西亚|雅加达/ {
                print
                while ((getline line < f) > 0) print line
                close(f)
                done = 1
                next
            }
            { print }
        ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
    else
        cat /tmp/india_lines.txt >> "$file"
    fi
    rm -f /tmp/india_lines.txt
fi
