# [H144-CHANGE4] dispatchagent cron 折叠候选盘点（只读报告）

> 数据源：`~/.hermes/profiles/dispatchagent/cron/jobs.json`（Mini 本机，2026-11-14 读取快照，`updated_at=2026-11-14T08:50:44+08:00`）。
> 本报告**只读盘点**：未改动任何 cron / 配置 / 运行面文件 / ledger。issue 原文写 69 个 cron，实测快照为 **70 个**（差额 1 个为 issue 撰写后新增的 job，见全量清单），以实测为准全量入表。

## 一、全量清单（70 条，逐条）

| 名称 | cron 表达式 | 启用 | 域 | 共享状态推断 |
|---|---|---|---|---|
| 🧬 每日统一进化（感知-提炼-行动） | `0 20 * * 1-6` | ✅ | 进化/记忆 | ~/.hermes/dreams/*.md、cron/output/<id>/、memories(WAL)；skills: self-evolve/auto-dream/memory-extract |
| 🧬 深度周进化（全面审查） | `0 22 * * 0` | ✅ | 进化/记忆 | 同上：dreams 报告 + memories + learning-promotion；与每日进化共享 backfill_evolve_reports.py |
| 🦞 Hermes 版本更新检查 | `0 12 * * 1` | ✅ | 版本运维 | hermes-agent git 仓库（fetch origin main）与本地版本状态 |
| 🧹 每周记忆GC+经验晋升 | `0 22 * * 6` | ✅ | 进化/记忆 | memories GC + 经验晋升，写 dreams（--prefix gc）；共享 backfill 脚本与记忆库 |
| 📚 微信读书资料库每日同步 | `5 7 * * *` | ✅ | 资料同步 | ~/.hermes/temp/weread_library.json（独立数据，无其他 cron 读） |
| 🔍 rag-index 每日增量索引 | `30 12 * * *` | ✅ | RAG/向量 | RAG 索引存储（增量索引）；与 mem-vec-daily 相邻调度、同族脚本 |
| 🧠 memory 向量索引增量 | `40 12 * * *` | ✅ | RAG/向量 | memory 向量索引；与 rag-index-daily 同域相邻（12:30/12:40） |
| 知识回访 rag 化 | `30 10 * * *` | ✅ | RAG/向量 | RAG 索引 + wiki 知识回访数据 |
| 🛡️ 判官漂移熔断巡检（omlx_judge META+VALIDATION） | `52 7 * * *` | ✅ | 模型巡检 | omlx_judge META+VALIDATION 状态（判官漂移熔断），纯脚本 |
| 🧠 oMLX/9B 每日巡检（三池+真推理+内存） | `22 7 * * *` | ✅ | 模型巡检 | oMLX/9B 三池+内存状态；与 judge 巡检同域相邻（07:22/07:52） |
| rsi-weekly-reflect | `30 6 * * 1` | ✅ | RSI 反思 | ~/logs/ 与 ~/.claude/ 近 7 天错误日志；写 ~/OUTPUTS/rsi-reflect-weekly/ |
| 🧠 记忆调度巡检（只读 L5 P1） | `17 8 * * *` | ✅ | 记忆巡检 | memory-scheduler-check.sh：记忆调度器状态（只读） |
| 👁 CC 动态监控（每15分钟） | `23 8,12,16,20 * * *` | ✅ | CC 监控 | CC 进程/tmux/文件改动（本机 CC 状态），8/12/16/20 点档 |
| 🚨 cron 失败巡检（未确认失败才推） | `7 * * * *` | ✅ | cron 基础设施 | jobs.json + executions.db + cron/output（失败巡检） |
| 🔍 读前写纪律巡检（未读先改才推） | `23 9 * * 1` | ✅ | 纪律巡检 | 读前写纪律检查（脚本化） |
| autodream-weekly | `17 23 * * 0` | ✅ | 进化/记忆 | hermes-memory 新增记忆（近 7 天）；写 ~/OUTPUTS/autodream/ |
| CC-RSI监控-pull通道 | `41 8,12,16,20 * * *` | ✅ | CC 监控 | CC-RSI 监控 pull 通道，与 aac11a34d23a 同档同时段 |
| 🔧 kittentts env 覆盖哨兵 | `23 */6 * * *` | ✅ | 环境维护 | 各 hermes venv 的 kittentts 覆盖（env 状态） |
| 👀 v0.21.7 发布监视 | `23 9 * * *` | ✅ | 版本运维 | hermes-agent 上游 release（v0.21.7）监视；与版本检查同源 |
| 🔍 Gateway重启夜间核验 | `13 8 * * *` | ✅ | Gateway 运维 | Gateway 夜间重启结果核验（读 gateway 状态/日志），依赖 3806e1b3d189 |
| 🧠 记忆分层回落复测 | `37 8 * * *` | ✅ | 记忆巡检 | 记忆分层回落状态复测 |
| 🔍 静默失效巡检 | `7 9 * * *` | ✅ | cron 基础设施 | 静默失效（假绿）检测；读 executions.db/cron output |
| 🌅 晨间仪式（能量刻度盘+感恩日记） | `15 7 * * *` | ✅ | 晨间推送 | feishu-card + VoiceStudio TTS；obviously-self 内容 |
| 🔥 Dan Koe 一天重置 | `23 8 * * *` | ✅ | 晨间推送 | feishu-card；独享 ~/.hermes/temp/odr_state.json |
| 💫 显化信条激励 | `47 11 * * *` | ✅ | 晨间推送 | feishu-card；obviously-self 心法内容 |
| 世界尽头咖啡馆-每日特调 | `30 7 * * *` | ✅ | 晨间推送 | feishu-card；独享 temp/cafe_rotation 轮换状态 |
| 🛡️ 每日凌晨安全检查+重启优化 | `20 6 * * *` | ✅ | 安全/Gateway | 每日安全自检（禁重启）；与 Gateway 状态间接相关 |
| 🎮 游戏版本同步总结 | `47 8 * * 1-5` | ✅ | 游戏同步 | /Users/vergiil/游戏/time-grocery git 仓库 |
| 🖥️ 每日双机巡检（Mini+MBP） | `0 18 * * *` | ✅ | 双机巡检 | Mini 本机状态 + ssh mbp 只读巡检（对照臂基线） |
| 🤖 CC进度晚报（Mini） | `30 21 * * *` | ✅ | CC 监控 | cc_digest.py --mode daily；CC 会话/记忆数据 |
| 📋 CC周任务晨报（周一） | `30 7 * * 1` | ✅ | CC 监控 | cc_digest.py --mode weekly；同一数据源 |
| 🧠 记忆向量索引自动维护 | `10 3 * * *` | ✅ | RAG/向量 | memory 向量索引维护（与 mem-vec-daily 同一索引，03:10 vs 12:40） |
| 🤖 AIHOT 行业精选 | `38 7 * * *` | ✅ | 晨间推送 | web-search-zai + feishu-card；独立检索 |
| 🎙️ VoiceStudio引擎守护(纯脚本) | `0 6 * * *` | ✅ | 语音 | VoiceStudio 引擎守护 |
| 🧠 RSI 每日主动服务（语音提问） | `30 11 * * *` | ✅ | RSI 服务 | RSI 语音提问主动服务 |
| RSI R1 reflector weekly digest | `30 8 * * 1` | ✅ | RSI 反思 | R1 reflector 周报 digest |
| 🖥️ 双机巡检·9B试点（试点臂·非对照） | `10 18 * * *` | ✅ | 双机巡检 | 与 c50366d02fc7 完全同域（9B 试点臂，非对照），同源双机状态 |
| 🦞 Hermes版本检查·9B试点 | `10 12 * * 1` | ✅ | 版本运维 | 与 711398f66ba9 同源（9B 试点臂），hermes-agent git |
| 🎮 游戏版本日报·9B试点 | `57 8 * * 1-5` | ✅ | 游戏同步 | 与 d0484407ec87 同一仓库（试点臂） |
| 🤖 CC进度晚报·9B试点 | `40 21 * * *` | ✅ | CC 监控 | 与 c50bfce578dc 同源 cc_digest（试点臂） |
| 📋 CC周任务晨报·9B试点 | `40 7 * * 1` | ✅ | CC 监控 | 与 edbd95fbc2a8 同源（试点臂） |
| 💫 显化信条·9B试点（MVP） | `57 11 * * *` | ✅ | 晨间推送 | 与 8d39ab2cc630 同内容域（试点臂） |
| wiki-stale-monthly | `17 8 1 * *` | ✅ | Wiki | wiki 陈旧内容巡检 |
| wikiclip-weekly | `30 8 * * 1` | ✅ | Wiki | wiki 剪藏周处理；与 wiki-summary-daily 同一 wiki 存储 |
| wiki-summary-daily | `30 3 * * *` | ✅ | Wiki | wiki 每日摘要；同上 |
| case-drift-guard-daily | `35 6 * * *` | ✅ | RSI 门禁 | case drift 守卫（RSI 案例/判例数据） |
| cc-rsi-monitor | `37 8,12,16,20 * * *` | ✅ | CC 监控 | cc-rsi-monitor 脚本，与 48f0c908231c/cf686409f7e9 同档同数据 |
| 🩺 Gateway健康检查（只读） | `17 */4 * * *` | ✅ | Gateway 运维 | Gateway 健康只读检查 |
| RSI memory harvest 每日记忆收割(A1) | `47 8 * * *` | ✅ | 进化/记忆 | RSI 记忆收割（A1）→ 记忆库 |
| 🛰️ RSI const-p1 调度器(C8观察·runs_on:mini) | `7,37 * * * *` | ✅ | RSI 调度 | const-p1 观察调度器（C8），runs_on mini，每半小时 |
| 🚨 中间异常 watcher（长任务消失/停滞+限流） | `*/10 * * * *` | ✅ | cron 基础设施 | 中间异常/长任务停滞 + 限流 watcher；读进程与执行记录 |
| 🔍 推送链路巡检(每小时) | `13 * * * *` | ✅ | cron 基础设施 | 推送链路（feishu 送达）巡检 |
| 🔄 Gateway定时重启 | `23 3 * * *` | ✅ | Gateway 运维 | restart-gateway.sh 定时重启；183953aa85dc 核验其结果 |
| 🌅 早安语音（The Teacher） | `5 7 * * *` | ✅ | 语音 | VoiceStudio TTS 早安语音 |
| 🎙️ 每日语音电台（A女青年播报版） | `55 7 * * *` | ✅ | 语音 | VoiceStudio TTS 电台播报 |
| 🎙️ 语音服务每日巡检（深度体检+自愈） | `10 6 * * *` | ✅ | 语音 | VoiceStudio 语音服务体检+自愈 |
| 🚦 J00x 门禁自测巡检（每日·静默） | `40 23 * * *` | ✅ | RSI 门禁 | J00x 门禁自测（23:40）；jgatewat01 验证它真的跑了 |
| 📊 J005 跨期漂移巡检（每周·静默） | `15 10 * * 0` | ✅ | RSI 门禁 | J005 跨期漂移巡检（同门禁数据） |
| 🛡️ 门禁看门人（验证23:40巡检真的跑了） | `45 23 * * *` | ✅ | RSI 门禁 | 读 23:40 巡检产物验证（与 jgate5097928 紧耦合） |
| 📋 RSI record 完整性守卫（第二期基线） | `50 22 * * *` | ✅ | RSI 门禁 | RSI record 完整性守卫（第二期基线记录） |
| 🔄 skills 单一真源同步（K013） | `10 4 * * *` | ✅ | 环境维护 | skills 单一真源同步（K013） |
| 🧩 cron 配置体检（每日·静默） | `43 8 * * *` | ✅ | cron 基础设施 | jobs.json 配置体检；与失败巡检同读 jobs.json |
| 🔬 M3.1-Flash GA 验证探针（一次性） | `5 20 19 10 *` | ⛔停用 | 一次性探针 | （已停用）M3.1-Flash GA 验证 |
| 🔬 M3.1-Flash 配额复测（成功才推） | `5 20 20 10 *` | ⛔停用 | 一次性探针 | （已停用）M3.1-Flash 配额复测 |
| 📊 9B 试点满月验收（OK率判定） | `30 9 23 11 *` | ✅ | 双机巡检 | 9B 试点满月验收：汇总试点臂各 cron 的 OK 率 |
| rsi-daily-brief | `10 9 * * *` | ✅ | RSI 简报 | RSI ledger/批次/门禁状态 → cc_delivery |
| rsi-event-probe | `*/30 * * * *` | ✅ | RSI 简报 | RSI verdict/门禁/观察窗事件；与 daily-brief 同一 ledger |
| memam-daily-evolve | `10 10 * * *` | ✅ | 进化/记忆 | MemoryAgentMaster 记忆健康六指标（memory_health_export.py）+画像 |
| 🛰️ HA 每日更新检查（SG 视角→推本群） | `20 8 * * *` | ✅ | 版本运维 | hermes-agent 上游更新（SG 视角）；与 711398f66ba9 同源重复 |
| 🧠 hermes-memory 二轮补缺巡检 | `47 9 * * 1` | ✅ | 记忆巡检 | hermes-memory 补缺扫描 |
## 二、折叠候选分组（紧耦合组，附合并理由）

1. **A1 进化/记忆报告族（7 条）**：每日统一进化、深度周进化、每周记忆GC+经验晋升、autodream-weekly、memam-daily-evolve、RSI memory harvest、hermes-memory 二轮补缺巡检。合并理由：全部读写同一记忆库（hermes memories / 画像）与同一报告落盘面（dreams / OUTPUTS / cron output），共享 backfill_evolve_reports.py 与 self-evolve/auto-dream/memory-extract 技能链；串行调用可消除对记忆库的并发写竞争。
2. **A2 RAG/向量索引族（4 条）**：rag-index-daily、mem-vec-daily、rag-review-daily、记忆向量索引自动维护。合并理由：同一向量索引存储的增量构建/回访/维护，可合成单条「索引维护」串行管道（03:10 与 12:40 两条对同一索引分头维护，状态最易漂移）。
3. **A3 9B 试点对照臂成对 job（6 对 + 1 验收）**：双机巡检、Hermes 版本检查、游戏版本日报、CC 进度晚报、CC 周任务晨报、显化信条各有一「试点臂」镜像；另有满月验收 job 汇总试点臂 OK 率。合并理由：每对读同一份数据、产出同构结果，仅推送通道不同；每对可合并为单 job 双臂输出，验收 job 可作为合并后 job 的内置月度分支。
4. **A4 CC 监控族（5 条）**：CC 动态监控、cc-rsi-monitor、CC-RSI监控-pull通道、CC 进度晚报（Mini）、CC 周任务晨报。合并理由：同一 CC 进程/会话/cc_digest 数据源，其中三条固定同档（8/12/16/20 点的 :37/:41/:23）几乎同时被调用；可合并为单条 CC 观测 job 分档输出。
5. **A5 Gateway 运维族（3 条）**：Gateway 定时重启（03:23）、重启夜间核验（08:13）、Gateway 健康检查（每 4h）。合并理由：核验 job 的唯一存在意义是验证重启 job 的结果——两者是直接上下游；健康检查同读 Gateway 状态，可并入同一「重启+自验」job。
6. **A6 门禁守卫族（2+2 条）**：J00x 门禁自测（23:40）与门禁看门人（23:45）是显式上下游（看门人只验证前者跑了）；J005 跨期漂移与 RSI record 完整性守卫同读门禁/记录数据。合并理由：23:40/23:45 相邻两条可合并为单 job 自验；J005 与 record 守卫可并入同域低频分支。
7. **A7 cron 基础设施巡检族（5 条）**：cron 失败巡检（每小时）、中间异常 watcher（每 10 分钟）、推送链路巡检（每小时）、静默失效巡检（每日）、cron 配置体检（每日）。合并理由：全部读 jobs.json / executions.db / cron output / 推送送达记录这同一组观测面；可合成单条「cron 可观测性」job（高频探测 + 日度汇总两档）。
8. **A8 语音服务族（5 条）**：VoiceStudio 引擎守护、语音服务每日巡检+自愈、早安语音、每日语音电台、晨间仪式（含语音段）。合并理由：共享 VoiceStudio 引擎健康状态，巡检/自愈是两条内容播报的前置依赖；可合并为「语音健康+当日播报」单管道。
9. **A9 版本更新检查族（3 条）**：Hermes 版本更新检查（周一）、HA 每日更新检查、v0.21.7 发布监视。合并理由：同源重复——都 fetch hermes-agent 上游并比对本地版本；可合并为单 job（日度检查 + 周报 + 特定版本监视开关）。
10. **A10 Wiki 维护族（3 条）**：wiki-summary-daily、wikiclip-weekly、wiki-stale-monthly。合并理由：同一 wiki 存储，日/周/月三档可并为单 job 按周期分支（耦合中等，合并收益主要是调度面收敛）。
11. **A11 RSI 周反思族（2 条）**：rsi-weekly-reflect、RSI R1 reflector weekly digest。合并理由：同为周一晨、同读近 7 天日志/会话数据做归纳，可并为单条周反思。

## 三、不建议折叠（无共享状态/低价值）

- **晨间内容推送**（晨间仪式、Dan Koe 一天重置、显化信条、世界尽头咖啡馆、AIHOT 行业精选）：内容相互独立、各自独享状态文件（odr_state/cafe_rotation），折叠只省调度开销且会挤占错峰推送时间。
- **微信读书资料库每日同步**：独享 weread_library.json，无其他 cron 消费。
- **kittentts env 覆盖哨兵、skills 单一真源同步**：环境维护域，与上述各族无共享状态。
- **游戏版本同步总结（对照臂）**：独立 git 仓库（仅与试点臂镜像成对，归入 A3 处理，不单独折叠）。
- **一次性探针**（M3.1-Flash GA 验证、配额复测，已停用）：一次性任务，无折叠意义（另：可考虑停用清理，但本报告不动它们）。
- **判官漂移熔断巡检、oMLX/9B 每日巡检**：虽同域相邻调度，但巡检对象与熔断动作不同，合并会增加单点复杂度——列为观察项，暂不建议折叠。
- **RSI 简报/探针/调度器**（rsi-daily-brief、rsi-event-probe、const-p1 调度器、case-drift-guard）：同读 RSI ledger，但分别承担简报/事件/调度/守卫四类职责，折叠会改变各自推送契约，暂不建议折叠。

## 四、声明

⛔ **折叠是独立决策**：任何实际折叠必须先走 H144 拓扑评估门 + 人工评审，本清单只是候选盘点，不构成执行授权；本报告产出过程未改动任何 cron / 配置 / 本机运行面（ledger/config/cron），未回写 ledger。
