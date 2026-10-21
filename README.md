
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

使用者影响：CLI 与 `@calcit/procs` 配对升级到正式 `0.30.1`；依赖使用已发布的
Quatrefoil 0.1.8、Quaternion 0.2.14、Pointed Prompt 0.0.19 和 JS-FFI 0.2.3，
不再使用旧 JS-FFI alpha tag，CI 改用 strict 模块解析。曲面公式、采样顺序、
默认参数、分段数、材质及原前端部署路径不变，不涉及后端服务或存量数据迁移。

速度、弯曲度、半径在真实状态入口解码为数值 Map，三条几何生成路径使用
`Map<Tag, Number>`，而不是逐次伪强转。正弦/余弦直接使用公开的带类型 core
`sin/cos`，删除两层重复的 Math 包装器及其逐采样解码；必要的 asin/tan 宿主
返回值仍做数值解码，不改写反三角公式或宣称所有三角函数均已原生化。
组件声明真实 Component 返回值，dispatch/reload 返回真实 Unit；Option 与 watcher
采用公开首选方法，清理未使用的容器状态读取。mobile-detect 的 `mobile()` 实际返回
字符串或 null，改用受检 host trait、`JsNullish<String>` 与 `js-present?`，不再虚报 Bool。

本地中间验收使用配对 alpha.5，不能冒充正式 0.30.1 验收。与保持原几何公式的中间
基线对比，四组参数共 2828 个曲线/曲面采样返回完全相同；默认渲染及通过本地辅助按钮
调用原 dispatch 的非零弯曲、零速度和 reload 已验收，不代表 VR/原 3D 控件全部验收。
初次迁移将源码 unsafe 6→0、schemaDynamic 19→14；后续 sin/cos 精简保持此边界，
没有重新放宽预算。仍有异构状态/dispatch 动态边界，
不宣称已完全类型化，不新增或放宽基线。正式工具链与构建由该提交的 Linux CI 验收；
不新增上传校验脚本，继续使用 COS Action 内置 verify，不提交 js-out 或本地验收页。

sin/cos 精简另以配对 alpha.5 中间环境对照 main 的原包装器实现，2828 个采样的
四个坐标完全一致。rotate-wave 增加一项附带原生回归（两条恒等旋转断言），CI
沿用完整 strict 并直接运行该测试，不增加脚本或测试框架。此回归不表示仍依赖
asin/tan 宿主方法的全部曲面路径都能在原生后端运行，也不作未测量的性能承诺。

### License

MIT
