# 开发与关联

本仓维护整合版本与验收清单（辅助仓）。游戏MOD的实际实现位于功能仓内，不在这里复制一套。

## 暂存与维护锁

审查Git差异并暂存有意提交的输入，再运行工具仓tools/Update-Lock.ps1 -RepositoryRoot <仓库>，暂存更新后的maintenance.lock.json，最后运行tools/Check-Commit.ps1。只检查一致性不等于构建或游戏实测通过。

新克隆用工具仓tools/Enable-Hooks.ps1 -CheckoutRoot <9仓目录>安装本机检查；Git不自动携带.git/hooks。本机钩子能被绕过，仍需人工审核与回归。不要向源码仓加入ZIP、日志、个人CFG或框架。必要的冻结DLL只允许repo.json登记路径。

## 安装包与提交状态

在干净源码提交上构建测试，用tools/Package-Release.ps1 -RepositoryRoot <仓库> -DestinationRoot <源码仓库之外> -Version <新标签>生成ZIP和包含准确源码提交的清单。

本地尚未提交时，仅可显式用-Preview做验收预览；清单中SourceCommit为空、ReleaseReady=false，BaseCommit只是修改前提交。预览不作为正式发布，不覆盖已发版本。构建输出记录当前输入锁与工具锁。

整合仓默认验证Repositories登记的精确源码提交、源码锁和干净工作区。PublishedBaseline保留原Releases标签、对应旧提交和下载验收记录；当前源码提交不冒用原安装包的哈希。RemoteAcceptance记录本次8个源码仓的远端克隆验收。

需要验证后续未提交改动时，再显式建立LocalWorkspace，登记8仓BaseCommit与SourceLockSHA256、BaseIntegrationCommit，并设置CommitCreated=false、Pushed=false；-LocalWorkspace核对暂存输入和基准HEAD，不替代默认的提交核验。完成提交后删除该临时字段，登记实际新提交并重新下载验收。
