# GTFO-Modpack-Manifest-and-Verification

跨仓整合与版本核验。本仓是辅助仓库，不是游戏MOD。

[定位入口](#modules) · [依赖与联动](#relations) · [开发与排查](#development) · [来源说明](#sources)

<a id="modules"></a>
## 定位入口

| 入口 | 用途 |
| --- | --- |
| [integration.json](integration.json) | 当前8个功能／工具仓精确提交和锁，以及独立的历史发布快照 |
| [Verify-All.ps1](Verify-All.ps1) | 核对源码锁、精确提交与干净工作区 |

本仓不存各MOD源码或安装ZIP。Repositories表示当前源码组合，PublishedBaseline表示已有安装候选及旧提交／附件哈希；两者不得混用。

<a id="relations"></a>
## 依赖与联动

按integration.json的Repositories检出对应精确提交，并将8仓与本仓放在同一父目录。核验使用旁边的[共用工具仓](https://github.com/PreLuna/GTFO-Mod-Build-and-Verification-Tools)。旧构建／回归证据与文档改动后的内容检查分别登记，文档更新不声称重新运行游戏或构建。

<a id="development"></a>
## 开发与排查

从本仓目录检查当前提交组合：

```powershell
./Verify-All.ps1
```

默认模式检查Repositories中的8个源码仓精确提交、维护锁和干净工作区，并检查本仓文件锁；不能用AllowUnpinned的内容检查冒充精确提交验收。

需要核验后续未提交改动时，先显式登记LocalWorkspace（8仓BaseCommit、SourceLockSHA256、BaseIntegrationCommit及CommitCreated=false、Pushed=false），再调用-LocalWorkspace。完成提交后移除临时字段，登记真实新提交，重新核对远端下载。

更新流程：先完成并推送功能／工具仓，登记其准确提交与锁，再提交整合仓。PublishedBaseline保持旧发布版本对应关系；远端源码检查、沿用的代码构建证据和游戏实测分别说明。通用输入登记与提交核验见[共用维护流程](https://github.com/PreLuna/GTFO-Mod-Build-and-Verification-Tools#maintenance)。

<a id="sources"></a>
## 来源说明

本仓库维护 PreLuna 的构建或整合资料。

保留源文件中的作者与版权声明。部分模组包含第三方派生实现或冻结基线，本说明不替代上游许可证，也不新增再分发授权；本仓库没有统一重授权声明。
