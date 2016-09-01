#LKDBKit

## 1. 概述
```
对于小型数据很方便, 声明一个继承于LKDBObject的类对象user
写入到数据库直接执行方法  [user insertToDb]; 
从数据库读取，NSArray *users = [User dbObjectsWhere:@"_id=11" orderby:nil];
更新到数据库，[user updateToDb];
从数据库删除，[user removeFromDb]; 
```

## 2. 使用方法

```
方法一：导入源码
方法二：项目支持cocoapods，在Podfile中添加pod LKDBKit
方法三：制作LKDBKit.framework并引入，可从附件中下载

支持模拟器和真机LKDBKit.framework制作方法:
   1. 分别在device和模拟器下运行
   2. 右击 LKDBKit.framework, 选择Show In Finder, 找到上级目录,本项目是release版本,
      这里显示Release-iphoneos,Release-iphonesimulator
   3. 把Release-iphoneos,Release-iphonesimulator文件夹拷贝到桌面
   4. 在终端运行lipo -create ~/Desktop/Release-iphoneos/LKDBKit.framework/LKDBKit \
      ~/Desktop/Release-iphonesimulator/LKDBKit.framework/LKDBKit \
      -output ~/Desktop/LKDBKit
   5. 在桌面文件夹Release-iphoneos上, 拷贝 LKDBKit.framework到桌面，把桌面上 LKDBKit 
      文件覆盖到LKDBKit.framework, 制作完成
   6. 在项目中引用LKDBKit.framework框架，支持模拟器和真机了
 * 引入依赖库sqlite3.dylib
 * 创建需要保存的数据类，该类需继承类LKDBObject
```

## 3. 示例

#####  1. 声明一个类，这里新建类User
```
#import "LKDBObject.h"
#import "LKDBQueue.h"
#import "LKDB.h"

 @interface User : LKDBObject

 @property (strong, nonatomic) NSString *name;
 @property (assign, nonatomic) NSInteger age;
 @property (strong, nonatomic) NSNumber *sex;
 @property (assign, nonatomic) NSTimeInterval time;
 @property (assign, nonatomic) int _id;

 @end
```
#####  2. 插入到数据库
```
方式一：
LKDBQueue *dbQueue = [LKDBQueue dbWithPath:@"LKDB_test/test_queue.sqlite"];
[dbQueue execute:^(LKDB *db) {
	User *user = [[User alloc] initWithPrimaryValue:8];
	user.name = @"aaa";
	[db insertDbObject:user];
}];
方式二：
LKDBQueue *dbQueue = [LKDBQueue dbWithPath:@"LKDB_test/test_queue.sqlite"];
[dbQueue execute:^(LKDB *db) {
	User *user = [[User alloc] initWithPrimaryValue:8];
	user.name = @"aaa";
	[user insertToDb:db];
}];
方式三：
LKDBQueue *dbQueue = [LKDBQueue dbWithPath:@"LKDB_test/test_queue.sqlite"];
[dbQueue execute:^(LKDB *db) {
	[db executeUpdate:@"insert into User(?) values(?)" dictionaryArgs:@{@"name" : @"aaa"}];
}];

```
#####  3. 查询
```
// 取出所有用户
方式一：
NSArray *users = [User allDbObjects];
方式二：
[dbQueue execute:^(LKDB *db) {
	[db executeQuery:@"select * from User" resultBlock:^(NSArray *resultArray) {
            NSLog(@"%@", resultArray);
	}];
}];
    
// 按条件取出数据
NSArray *users = [User dbObjectsWhere:@"_id=11" orderby:nil];

```
#####  4. 修改
```
// 首先从数据库中取出要修改的对象
方式一：
NSArray *users = [User dbObjectsWhere:@"_id=11" orderby:nil];
if ([users count] > 0) {
   User *user = users[0];
   user.name = @"学长";
   // 更新到数据库
   [user updateToDb];
}
方式二：
[dbQueue execute:^(LKDB *db) {
	[user updateToDb:db];
}];
```
#####  5. 删除
```
// 要删除的数据
方式一：
User *user = _users[row];
// 从数据库中删除数据
[user removeFromDb];
方式二：
[dbQueue execute:^(LKDB *db) {
	[db executeQuery:@"delete from User where __id__=8"];
	}];
}];
// 批量删除
[User removeDbObjectsWhere:@"_id=%d", 4];
```
**注意：** *一旦修改了数据类，请删除原来的应用重新运行。本项目内置了日期相关方法，详情参见* 
