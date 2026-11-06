# AGENTS.md — daily-board 仓库执行须知

本仓库由 dsh-superagent 底座驱动。Executor 在本仓库工作时遵守以下约定。

## 可用下家（dispatch relay）

需要本仓库工具面之外的能力时，可派活给以下执行下家。每单必须：边界明确（一句话任务 + 完成判据）、一次性、不递归。

### HA（本机 hermes agent）— 管家域下家

```sh
hermes -z "<任务描述>。完成后只输出结果正文。"
```

- 耗时 8–120s。适用：SG 节点状态查询、双机体系记忆检索、cron/渠道任务、飞书事件核对。

### CC（MBP Claude Code）— 重活下家（经 Mini 一跳中转）

```sh
ssh -o BatchMode=yes -o ConnectTimeout=10 mini "python3 ~/scripts/sdk-dispatch.py quick '<任务描述>'"
```

- 耗时 30s–10min。适用：复杂编码、文档生成、深度研究（MBP 主力机算力）。
- 输出：JSON（取 `result` 字段）。

### ZCode（MBP GLM CLI）— 第四下家（待启用）

```sh
ssh -o BatchMode=yes -o ConnectTimeout=10 mini "/Applications/ZCode.app/Contents/Resources/glm/zcode.cjs -p '<任务描述>'"
```

- **前置条件：MBP 上 `zcode login` 已完成（尚未配置，调用会 AI_APICallError）。启用前勿派。**
- 经 Mini 一跳中转。适用：GLM 模型族任务，与 CC 互补（异族双保险）。

### DSH 跨实例互派（Mini 节点 superagent）— 编队协同

```sh
ssh -o BatchMode=yes mbp 'source ~/.superagent/tokens.env && curl -s -X POST http://127.0.0.1:3083/orchestrator/api/operator/trigger -H "x-orchestrator-request: 1" -H "x-operator-token: $MINI_TOKEN" -H "Host: 127.0.0.1:3083" -H "Origin: http://127.0.0.1:3083" -H "Content-Type: application/json" -d "{\"key\":\"<唯一幂等键>\",\"title\":\"<标题>\",\"text\":\"<任务正文>\",\"actor\":\"vergiil\"}"'
```

- 走 MBP 隧道 3083→Mini 实例，actor=vergiil 在 Mini policy 名单内（explicit mandate）。
- 适用：需要 Mini 节点（super-RSI-agent 仓库/Mini HA/oMLX 本地算力）的任务。仅限明确需要对方节点能力的场景。
- 结果无回复通道：经 Mini 工单 outcome / GitHub PR / MBP 面板观察（superdispatch 亦可查询）。

## 铁律

1. 只派边界清晰的一次性任务；不带任何 secret；不递归派活（下家的下家不存在）。
2. 下家失败或超时一次即放弃，把失败原样写进 Report，不重试轰炸。
3. 下家输出原样带回 report，不加工、不删减关键数据。
4. 先自力后派活——本仓库工具面（bash/gh/read/edit）能干的别麻烦下家。
