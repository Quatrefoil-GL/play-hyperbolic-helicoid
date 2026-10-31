Play Hyperbolic Helicoid
----

Live demo: http://repo.quamolit.org/play-hyperbolic-helicoid
Video: https://www.bilibili.com/video/BV1qq4y1o7uK
Inspired by https://www.youtube.com/watch?v=0e5vzTsLh2s

### 使用者影响

配对使用正式 Calcit CLI/procs 0.32.1，类型标注由官方 CLI 迁移。
Quatrefoil 0.2.0、Quaternion 0.2.19、Touch Control 0.0.35、Pointed Prompt 0.0.24、
JS-FFI 0.2.9 组成一致的正式依赖图。包龄明确为 60 分钟，无单版本豁免。
保留原类型/质量门禁和 hud! 页面提示，不新增验证脚本或测试框架，不提交生成目录。

曲面公式、采样顺序、默认速度/弯曲/半径、材质、状态解码及派发合同不变。
21个项目定义的code/schema/元数据/原测试与官方格式化基线完全一致。
旧@quamolit/quatrefoil-utils改为已存在的@quatrefoil/utils，其注入实现文件哈希一致；
触控CSS从对应Caps模块加载，也与旧npm CSS哈希一致，因此移除两个重复npm包。
Actions换为与原SHA对应的精确正式tag，接受可移动tag风险；移除过期procs包龄豁免。

### 开发与验收

```sh
caps --strict --ci
yarn install --immutable
caps verify --toolchain
yarn compile
cp assets/* js-out/
yarn dev
```

完整strict、230/230定义、21/21公开定义、原rotate-wave附带测试、编译和构建通过。
该原测试只覆盖恒等旋转，不将仍依赖asin/tan宿主的全部曲面路径冒充原生后端支持。
实际IAB默认曲面、相机和刷新验收；未重做所有参数拖动、非零曲率、VR、移动硬件或跨GPU验收。
保留真实异构状态/派发边界，不宣称类型债务清零。

COS使用action1.2.0内置verify，无额外上传校验脚本。PR编号/run/attempt目录隔离，
原生产CDN和rsync路径、条件不变；完整CI与实际COS结果在PR记录，不合并部署生产。

### License

MIT
