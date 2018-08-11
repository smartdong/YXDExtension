//
//  YXDMacroExtensionHeader.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

/*--------------------------------开发中常用到的宏定义--------------------------------------*/

//系统目录
#define kDocuments          ((NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])
#define kCaches             ((NSString *)[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject])
#define kLibrary            ((NSString *)[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define kTemp               ((NSString *)[NSString stringWithFormat:@"%@/temp", kCaches])

//方法简写
#define mApplication        [UIApplication sharedApplication]
#define mAppDelegate        ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define mWindow             ((UIWindow *)[[[UIApplication sharedApplication] windows] firstObject])
#define mKeyWindow          [[UIApplication sharedApplication] keyWindow]
#define mUserDefaults       [NSUserDefaults standardUserDefaults]
#define mNotificationCenter [NSNotificationCenter defaultCenter]

//当前设备的系统版本
#define mSystemVersion      ([[[UIDevice currentDevice] systemVersion] floatValue])
//当前app版本
#define mAppVersion         ((NSString *)[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"])

//屏幕尺寸
#define mScreenWidth        ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight       ([UIScreen mainScreen].bounds.size.height)

//设备尺寸判断
#define iPhone4Size         (CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size))
#define iPhone5Size         (CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size))
#define iPhone6Size         (CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size))
#define iPhone6PlusSize     (CGSizeEqualToSize(CGSizeMake(621, 1104), [UIScreen mainScreen].bounds.size))
#define iPhoneXSize         (CGSizeEqualToSize(CGSizeMake(375, 812), [UIScreen mainScreen].bounds.size))

//加载图片
#define mImageByName(name)        [UIImage imageNamed:name]
#define mImageByPath(name, ext)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:ext]]

//根据数字生成字符串
#define mNSStringByInt(value)       [NSString stringWithFormat:@"%d",value]
#define mNSStringByDouble(value)    [NSString stringWithFormat:@"%f",value]

//生成cgpoint生成字符串 、 cgsize 、 cgrect
#define mNSStringWithCGPoint(x, y)                  NSStringFromCGPoint(CGPointMake(x, y))
#define mNSStringWithCGSize(width, height)          NSStringFromCGSize(CGSizeMake(width, height))
#define mNSStringWithCGRect(x, y, width, height)    NSStringFromCGRect(CGRectMake(x, y, width, height))

//根据字符串生成cgpoint 、 cgsize 、 cgrect
#define mCGPointWithNSString(string)                CGPointFromString(string)
#define mCGSizeWithNSString(string)                 CGSizeFromString(string)
#define mCGRectWithNSString(string)                 CGRectFromString(string)

//以tag读取View
#define mViewByTag(parentView, tag, Class)  ((Class *)[parentView viewWithTag:tag])
//读取Xib文件的类
#define mViewByNib(Class, owner) [[[NSBundle mainBundle] loadNibNamed:Class owner:owner options:nil] lastObject]

//id对象与NSData之间转换
#define mObjectToData(object)   [NSKeyedArchiver archivedDataWithRootObject:object]
#define mDataToObject(data)     [NSKeyedUnarchiver unarchiveObjectWithData:data]

//度弧度转换
#define mDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define mRadianToDegrees(radian) (radian*180.0) / (M_PI)

//生成颜色
#define mRGBColor(r, g, b)          [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define mRGBAColor(r, g, b, a)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//设置颜色值：UIColorFromRGB(0x067AB5)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//GCD相关方法
#define kGCDBackground(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define kGCDMain(block)       dispatch_async(dispatch_get_main_queue(),block)

//简单的以AlertView显示提示信息
#define mAlertView(title, msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil]; \
[alert show];

//SharedInstance
#define SharedInstanceDeclare + (instancetype)sharedInstance;
#define SharedInstanceImplementation \
+ (instancetype)sharedInstance { \
static id sharedInstance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
    sharedInstance = [self new]; \
}); \
return sharedInstance; \
}

//触摸点在视图中的位置
#define TouchPointInView(view) [((UITouch *)[[[event allTouches] allObjects] firstObject]) locationInView:view]

//Weak Strong Declare
#define WeakSelfDeclare     typeof(self) __weak weakSelf = self;
#define StrongSelfDeclare   typeof(weakSelf) __strong self = weakSelf;

#define WeakDeclare(obj)    typeof(obj) __weak weakObj = obj;
#define StrongDeclare(obj)  typeof(weakObj) __strong obj = weakObj;

//Assert Define
#define YXDAssert(msg)              NSAssert(0, msg);
#define YXDOverrideAssert           NSAssert(0, @"Subclass should override this method !");
#define YXDTypeAssert(obj, type)    NSAssert([obj isKindOfClass:[type class]], @"Type check error, expect %@, actually is %@", [type class], [obj class]);

/*--------------------------------一些方法简写--------------------------------------*/

//root view controller
#define mRootViewController                     ((AppDelegate *)([UIApplication sharedApplication].delegate)).window.rootViewController

//从bundle中加载cell
#define mLoadNib(name)                          [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] lastObject]
#define mLoadNibWithClass(clazz)                [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(clazz) owner:self options:nil] lastObject]

//注册nib
#define mRegisterNib_TableView(view,name)       [view registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:name]
#define mRegisterNib_CollectionView(view,name)  [view registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name]

//加载故事板
#define mLoadStoryboard(storyboardName)         [UIStoryboard storyboardWithName:storyboardName bundle:nil]

//从故事板中加载vc
#define mLoadViewController(storyboard,viewControllerName)  [storyboard instantiateViewControllerWithIdentifier:viewControllerName]

