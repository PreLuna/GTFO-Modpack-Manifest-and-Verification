# GTFO-Modpack-Manifest-and-Verification

跨仓提交、维护锁与安装包哈希登记。本仓不存放各MOD源码，不提供游戏安装ZIP。

integration.json的Repositories锁定本次MOD目录整理后已提交、推送的8个功能／工具仓源码，RemoteAcceptance记录从GitHub重新克隆后的构建与回归。PublishedBaseline保留整理前源码、candidate-20261020安装包及其下载验收记录；本轮没有发布或覆盖安装包。

当前检查：`./Verify-All.ps1`，核对准确提交、源码锁和干净工作区。未来需要核验未提交改动时，显式登记LocalWorkspace后才能使用-LocalWorkspace；本次源码不再处于未提交预览状态。

7个功能仓的原安装包仍在各自Releases；[整合清单](integration.json) 分别记录当前源码和既有发布版本。使用与维护见 [DEVELOPMENT.md](DEVELOPMENT.md)。
