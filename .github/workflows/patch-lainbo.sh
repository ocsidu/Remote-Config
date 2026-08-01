#!/usr/bin/env bash
set -euo pipefail

file="src/Clash/RemoteConfig/Lainbo.ini"

sed -i 's/|isp|/|/g' "$file"
sed -i '/^exclude_remarks/a\\nruleset=✈️ 节点选择,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/CustomProxy.list\n\nruleset=💬 AI专用,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/CustomAI.list\n\nruleset=🇺🇸 美国自动,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/America.list\n\nruleset=🇺🇸 美国自动,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/GoogleAI.list\n\nruleset=🇪🇺 欧洲自动,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/Europe.list\n\nruleset=🇯🇵 日本自动,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/Japan.list\n\nruleset=🎵 RYM和其他刁钻网站,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/RYMandMore.list\n\nruleset=📚 EH专用,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/EH.list\n\nruleset=🔗 无需代理,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/CustomDirect.list' "$file"
sed -i '/^custom_proxy_group=💬 AI专用/a\custom_proxy_group=🎵 RYM和其他刁钻网站`select`[]✈️ 节点选择`[]🇸🇬 狮城自动`[]🇺🇸 美国自动`[]🇪🇺 欧洲自动`[]🇭🇰 香港自动`[]🇨🇳 台湾自动`[]🇯🇵 日本自动`.*`[]DIRECT\ncustom_proxy_group=📚 EH专用`select`[]✈️ 节点选择`[]🇸🇬 狮城自动`[]🇺🇸 美国自动`[]🇪🇺 欧洲自动`[]🇭🇰 香港自动`[]🇨🇳 台湾自动`[]🇯🇵 日本自动`.*`[]DIRECT' "$file"

# 找出两类行
india_line=$(grep -E '印度|孟买|加尔各答|贾坎德' "$file" | head -n1 || true)

if [ -n "$india_line" ]; then
    # 1. 删除原来的印度行
    sed -i '/印度\|孟买\|加尔各答\|贾坎德/d' "$file"
    # 2. 把印度行插到印尼行之后
    if grep -qE '印尼|印度尼西亚|雅加达' "$file"; then
        sed -i "/印尼\|印度尼西亚\|雅加达/a ${india_line}" "$file"
    else
        # 没有印尼行，就追加到文件末尾（兜底）
        echo "$india_line" >> "$file"
    fi
fi
