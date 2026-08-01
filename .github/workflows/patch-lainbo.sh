#!/usr/bin/env bash
set -euo pipefail

file="src/Clash/RemoteConfig/Lainbo.ini"

sed -i 's/|isp|/|/g' "$file"
sed -i '/^exclude_remarks/a\\nruleset=✈️ 节点选择,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/CustomProxy.list\n\nruleset=💬 AI专用,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/CustomAI.list\n\nruleset=🇺🇸 美国自动,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/America.list\n\nruleset=🇺🇸 美国自动,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/GoogleAI.list\n\nruleset=🇪🇺 欧洲自动,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/Europe.list\n\nruleset=🇯🇵 日本自动,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/Japan.list\n\nruleset=🎵 RYM和其他刁钻网站,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/RYMandMore.list\n\nruleset=📚 EH专用,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/EH.list\n\nruleset=🔗 无需代理,https://raw.githubusercontent.com/ocsidu/Remote-Config/refs/heads/main/src/Clash/List/CustomDirect.list' "$file"
sed -i '/^custom_proxy_group=💬 AI专用/a\custom_proxy_group=🎵 RYM和其他刁钻网站`select`[]✈️ 节点选择`[]🇸🇬 狮城自动`[]🇺🇸 美国自动`[]🇪🇺 欧洲自动`[]🇭🇰 香港自动`[]🇨🇳 台湾自动`[]🇯🇵 日本自动`.*`[]DIRECT\ncustom_proxy_group=📚 EH专用`select`[]✈️ 节点选择`[]🇸🇬 狮城自动`[]🇺🇸 美国自动`[]🇪🇺 欧洲自动`[]🇭🇰 香港自动`[]🇨🇳 台湾自动`[]🇯🇵 日本自动`.*`[]DIRECT' "$file"

# 找出印度行（只取第一行匹配）
india_line=$(grep -m1 -E '印度|孟买|加尔各答|贾坎德' "$file" || true)

if [ -n "$india_line" ]; then
    # 1. 删除原来的印度行
    sed -i '/印度\|孟买\|加尔各答\|贾坎德/d' "$file"
    # 2. 用 awk 把印度行插到第一个印尼行之后（内容原样，不怕特殊字符）
    if grep -qE '印尼|印度尼西亚|雅加达' "$file"; then
        awk -v ins="$india_line" '
            !done && /印尼|印度尼西亚|雅加达/ { print; print ins; done=1; next }
            { print }
        ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
    else
        # 没有印尼行，追加到末尾兜底
        printf '%s\n' "$india_line" >> "$file"
    fi
fi
