# YXDExtension
注意事项：

* 自己搞着玩的项目，没在线上项目上验证过
* 功能是依自己想法去加的，不一定满足实际需求，将来在使用上出了偏差本人不负责
* 有`bug`或者代码有需要改正的地方，跪求大神们指点 _(:3」∠❀)_

使用:

* 将`YXDExtension`文件夹拖入项目
* 导入需要的头文件或直接`#import "YXDExtensionHeader.h"` 

需要添加如下`Frameworks`:（如不需要相关功能，则直接删除对应目录也可）
* `libz.tbd`（`Zip`文件操作 对应目录如下）
    * `YXDExtension/Vendor/SSZipArchive`
* `libsqlite3.tbd`（`sqlite`操作 对应目录如下）
    * `YXDExtension/Vendor/FMDB`
    * `YXDExtension/Vendor/YYCache`
    * `YXDExtension/YXDFunctionExtension/YXDFMDBHelper`
    * `YXDExtension/YXDFunctionExtension/YXDCache`
