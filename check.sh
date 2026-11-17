#!/usr/bin/env bash
# daily-board 一键校验 — 5 秒级反馈（pre-commit 钩子自动运行）
# 用法: ./check.sh
# 全绿: 逐行 ✓ + 退出 0；任一失败: ✗ + 退出 1，禁止提交。
set -u
FAIL=0
step() { if [ "$1" -eq 0 ]; then echo "✓ $2"; else echo "✗ $2" >&2; FAIL=1; fi; }

# 1) 看板数据：可解析 + 必备键
python3 -c "import json; d=json.load(open('dashboard.json')); assert all(k in d for k in ('generated_at','today','stats'))" 2>/dev/null
step $? "dashboard.json 可解析且含必备键 (generated_at/today/stats)"

# 2) 约定文件在位
[ -s AGENTS.md ]; step $? "AGENTS.md 存在且非空"
[ -s README.md ]; step $? "README.md 存在且非空"

# 3) markdown 相对链接全部指向存在的文件
python3 - <<'PYEOF'
import os, re, sys
bad = []
for root, dirs, files in os.walk('.'):
    dirs[:] = [d for d in dirs if d not in ('.git', 'node_modules')]
    for f in files:
        if not f.endswith('.md'):
            continue
        p = os.path.join(root, f)
        text = open(p, encoding='utf-8', errors='replace').read()
        for m in re.finditer(r'\[[^\]]*\]\(([^)#\s]+)\)', text):
            link = m.group(1)
            if link.startswith(('http://', 'https://', 'mailto:')):
                continue
            if not os.path.exists(os.path.normpath(os.path.join(root, link))):
                bad.append(f'{p}: 断链 {link}')
if bad:
    print('\n'.join(bad), file=sys.stderr)
    sys.exit(1)
PYEOF
step $? "markdown 相对链接全部有效"

if [ "$FAIL" -eq 1 ]; then
  echo "—— 校验未通过，禁止提交（修复后重跑 ./check.sh）" >&2
  exit 1
fi
echo "—— 全部通过"
