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
ssh -o BatchMode=yes mini "python3 ~/scripts/sdk-dispatch.py quick '<任务描述>'"
```

- 耗时 30s–10min。适用：复杂编码、文档生成、深度研究（MBP 主力机算力）。
- 输出：JSON（取 `result` 字段）。

## 铁律

1. 只派边界清晰的一次性任务；不带任何 secret；不递归派活（下家的下家不存在）。
2. 下家失败或超时一次即放弃，把失败原样写进 Report，不重试轰炸。
3. 下家输出原样带回 report，不加工、不删减关键数据。
4. 先自力后派活——本仓库工具面（bash/gh/read/edit）能干的别麻烦下家。
