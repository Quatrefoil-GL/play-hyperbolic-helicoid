
Play Hyperbolic Helicoid
----

> Based on [Quatrefoil](https://github.com/Quamolit/quatrefoil.calcit).

Live demo: http://repo.quamolit.org/play-hyperbolic-helicoid

Video demo: https://www.bilibili.com/video/BV1qq4y1o7uK

### About

Inspired by https://www.youtube.com/watch?v=0e5vzTsLh2s

![image](https://user-images.githubusercontent.com/449224/134778726-e509522c-9197-4760-8df8-9c04040767ab.png)


### Workflow

COS 上传使用 Action 1.2 内置 `public-base-url` verify，不增加独立上传校验脚本。
PR 预览按 PR 编号/run/attempt 隔离；生产前缀与原服务器部署路径保持不变。
串行队列保留待运行任务，构建和上传分别设定超时。Calcit 版本从 `deps.cirru`
读取并由 Caps 工具链检查，避免在工作流重复硬编码版本。

当前保持正式 Calcit/procs 0.27.0。正式 0.28 的只读检查被已发布 Quatrefoil
0.1.5 中的 Option/spread 旧用法阻塞；等待兼容模块发布，不使用 hash 或新增 alpha
依赖绕过，也不宣称本次部署改造已经完成语言升级。原 Caps 非 strict 安装仍存在
JS-FFI 版本冲突警告，类型分析也仍有 partial/Dynamic 债务，未放宽或移除现有门禁。

### License

MIT
