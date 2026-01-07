#!/usr/bin/env bash
set -euo pipefail

file="src/Clash/RemoteConfig/Lainbo.ini"

sed -i 's/|ispl//g' "$file"
sed -i '/^exclude_remarks/a\\nruleset=✈️ 节点选择,https://raw.githubusercontent.com/LeflyChan/Remote-Config/refs/heads/main/src/Clash/List/CustomProxy.list\nruleset=💬 AI专用,https://raw.githubusercontent.com/LeflyChan/Remote-Config/refs/heads/main/src/Clash/List/CustomAI.list\nruleset=🇺🇸 美国自动,https://raw.githubusercontent.com/LeflyChan/Remote-Config/refs/heads/main/src/Clash/List/America.list\nruleset=🇪🇺 欧洲自动,https://github.com/LeflyChan/Remote-Config/raw/refs/heads/main/src/Clash/List/Europe.list\nruleset=🇯🇵 日本自动,https://raw.githubusercontent.com/LeflyChan/Remote-Config/refs/heads/main/src/Clash/List/Japan.list\nruleset=🔗 无需代理,https://raw.githubusercontent.com/LeflyChan/Remote-Config/refs/heads/main/src/Clash/List/CustomDirect.list\n' "$file"
