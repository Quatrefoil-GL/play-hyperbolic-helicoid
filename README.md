Play Hyperbolic Helicoid
----

Live demo: http://repo.quamolit.org/play-hyperbolic-helicoid
Video: https://www.bilibili.com/video/BV1qq4y1o7uK
Inspired by https://www.youtube.com/watch?v=0e5vzTsLh2s

### Calcit 0.40.0 使用说明

升级时同时使用正式 Calcit 和 `@calcit/procs` 0.40.0，重新安装依赖并构建。
本地开发若有旧版热重载会话，刷新页面以重建场景状态。
速度、弯曲、半径的默认值和操作方式沿用原版。

控件和几何函数共用 `HelicoidState`，三个字段都必须是 Number。
渲染入口通过 `HelicoidPayload` 兼容旧数值 Map，并继续接受直接游标和旧 `:states` pair。
缺字段或类型错误会在修改场景前报错，`nil` 和 `false` 仍恢复默认值。
只有 `[:helicoid]` 游标能更新本页的曲面状态。

### 历史：0.34.2 迁移

配对使用正式 Calcit CLI/procs 0.34.2、Quatrefoil 0.3.0、Quaternion 0.2.19、
Touch Control 0.0.36、Pointed Prompt 0.0.24、JS-FFI 0.2.9。
旋转输入收紧为三个 Number 的 Tuple；曲线、曲面与四元数位置结果明确为四项
[x y z s] Tuple，保留第四项标量，未改成三项或 JS Array。

从正式 Quatrefoil 0.2.0 升级时，parametric 的 :data 由原值/nil 改为 Option。
本应用在组件回调入口解包并检查 Number Map，再调用原纯数学 surface-fn。
这修复实际 Three 曲面构建时的 `&map:get expected a Map`；并非 Tuple 公式变化。
公开回调仍缺少数据类型传播，已报告 [Quatrefoil #86](https://github.com/Quatrefoil-GL/quatrefoil/issues/86)。

除官方格式化外，21 个原定义仅六个有上述合同/入口调整：五个几何函数，
以及 comp-helicoid 中的 parametric 适配；原测试、FFI 元数据和其他定义保持。
rotate-wave 使用 let[] 读取三项，替代三次可选下标解包；数值表达式和计算顺序保持。
原曲面公式、采样密度、默认值、材质、状态派发、HUD、应用版本及部署路径不变。
回调入口的 Option Dynamic 是库当前真实边界，经过显式检查后才进入数学函数；
未新增 unsafe、门禁例外、永久脚本或测试框架，原 unresolved 统计仍为 9。

### 开发与验收

```sh
caps --strict --ci
yarn install --immutable
caps verify --toolchain
yarn compile
cp assets/* js-out/
yarn dev
```

本轮完整strict、230/230定义、21/21公开定义、原rotate-wave附带测试、编译和构建通过。
该原测试只覆盖恒等旋转，不将仍依赖asin/tan宿主的全部曲面路径冒充原生后端支持。
此前 0.32.1 实际IAB默认曲面、相机和刷新验收；未重做所有参数拖动、非零曲率、VR、移动硬件或跨GPU验收。
保留真实异构状态/派发边界，不宣称类型债务清零。

本轮正式 Caps strict/CI、immutable、工具链、全部原质量检查和构建通过。
临时 Vite 内存对照在同一 0.3.0 模块图比较原、新纯数学函数，105 组四坐标采样完全一致；
修复后的默认/非零弯曲场景均生成两条管线（10413/5213 顶点）和一张曲面（10201 顶点），
坐标有限。未修复的原回调在新图构建会失败，因此不宣称原、新完整场景等价验收通过。
模块初始化的 div/键盘监听占位不代表 DOM/控件或 WebGL 验收；WebSocket 绑定限制与
重复 Three 警告已记录。没有重做视觉、VR 或跨 GPU 验收，最终 CI/COS 待远端执行。

COS使用action1.2.0内置verify，无额外上传校验脚本。PR编号/run/attempt目录隔离，
原生产CDN和rsync路径、条件不变；完整CI与实际COS结果在PR记录，不合并部署生产。

### License

MIT
