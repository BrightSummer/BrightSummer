//
//  ViewController.m
//  coredata的简单使用
//
//  Created by ming on 16/4/16.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Employee.h"
#import "Department.h"

@interface ViewController ()
@property(strong,nonatomic) NSManagedObjectContext *context;
@end

@implementation ViewController

#pragma mark 模糊查询
- (IBAction)likeSearcher:(id)sender {
    // 查询
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    // 过滤
//    // 1.查询以 wang 开头的员工
//    NSPredicate *pre= [NSPredicate predicateWithFormat:@"name BEGINSWITH %@",@"wang"];
//    request.predicate = pre;
    
//    // 2.查询以 si 结尾的员工
//    NSPredicate *pre= [NSPredicate predicateWithFormat:@"name ENDSWITH %@",@"si"];
//    request.predicate = pre;
    
//    // 3.包含 g
//    NSPredicate *pre= [NSPredicate predicateWithFormat:@"name CONTAINS %@",@"g"];
//    request.predicate = pre;
    
    // 3. like si 结尾
    NSPredicate *pre= [NSPredicate predicateWithFormat:@"name like %@",@"*si"];
    request.predicate = pre;
    
    NSError *error= nil;
    NSArray *emps = [self.context executeFetchRequest:request error:&error];
    if(!error){
        NSLog(@"%@",emps);
        for(Employee *emp in emps){
            NSLog(@"%@ %@ %@",emp.name, emp.age, emp.height);
        }
    }else{
        NSLog(@"%@",error);
    }
}


- (NSArray *)findEmployeeWithName:(NSString *) name{
    // 查找员工
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@",name];
    request.predicate = pre;
    return [self.context executeFetchRequest:request error:nil];
}

#pragma mark 更新员工信息
- (IBAction)updateEmployee:(id)sender {
    // 更改 wangwu 的身高为 1.7
    
    // 查找 wangwu
    NSArray *emps = [self findEmployeeWithName:@"wangwu"];
    
    // 更新身高
    if(emps.count==1){
        Employee *emp = emps[0];
        emp.height = @1.7;
    }
    // 同步 （保存）到数据库
    [self.context save:nil];
}


#pragma mark 删除员工
- (IBAction)deleteEmployee:(id)sender {
    [self deleteEmployeeWithName:@"lisi"];
}

- (void) deleteEmployeeWithName:(NSString *) name{
    // 删除 zhangsan
    // 1.查找 zhangsan
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@",name];
    request.predicate = pre;
    
    // 2.删除 zhangsan
    NSError *error = nil;
    NSArray *emps = [self.context executeFetchRequest:request error:&error];
    for (Employee *emp in emps) {
        NSLog(@"删除员工 %@", emp.name);
        [self.context deleteObject:emp];
    }
    
    // 3.用context同步数据库
    // 所有操作暂时存在内存，需要调用 save 同步到数据库
    [self.context save:nil];
}

#pragma mark 读取员工信息
- (IBAction)readEmployee:(id)sender {
    
    // 创建一个请求对象 (填入要查询的表名=实体类）
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    // 过滤查询
    // 查询zhangsan
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"depart.name = %@",@"ios"];
    request.predicate = pre;
    
//    // 分页查询 总共13条数据 每页显示5条数据
//    // 第一页数据
//    request.fetchLimit = 5;
//    request.fetchOffset = 5;
    
    
    // 排序 以身高升序排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 读取信息
    NSError *error = nil;
    NSArray *emps = [self.context executeFetchRequest:request error:&error];
    if(!error){
        NSLog(@"emps: %@", emps);
        for(Employee *emp in emps){
            NSLog(@"name:%@ departName:%@",emp.name, emp.depart.name);
        }
    }else{
        NSLog(@"%@",error);
    }
    
    
}

#pragma mark 添加员工信息
- (IBAction)addEmployee:(id)sender {
    // 添加 zhangsan 属于 ios 部门
    Employee *emp1 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.context];
    emp1.name = @"zhangsan";
    emp1.height = @1.7;
    emp1.age = @27;
    
    // 创建 ios 部门
    Department *dep1 = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:self.context];
    dep1.name = @"ios";
    dep1.createDate = [NSDate date];
    dep1.departNo = @"D001";
    
    emp1.depart = dep1;
    
    // 添加 lisi 属于 android 部门
    Employee *emp2 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.context];
    emp2.name = @"lisi";
    emp2.height = @1.7;
    emp2.age = @27;
    
    // 创建 android 部门
    Department *dep2 = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:self.context];
    dep2.name = @"android";
    dep2.createDate = [NSDate date];
    dep2.departNo = @"D002";
    
    emp2.depart = dep2;
    
    //一次性保存
    [self.context save:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 创建一个数据库 company.sqlite
    // 数据库里要有一张 员工表 （name, age, height)
    // 往数据库添加员工信息
    // coreData
    [self setupContext];
    
    
}

- (void) setupContext{
    // 上下文 关联Company.xcdatamodeld 模型文件
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    
    // 关联模型文件
    
    // 创建一个模型对象
    // 传一个nil 会把 bundle 下的所有模型关联起来
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 持久化存储调度器
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    context.persistentStoreCoordinator = store;
    
    // 存储数据库的名字
    NSError *error = nil;
    
    // 获取 doc 目录
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 数据库保存的路径
    NSString *sqlitePath = [doc stringByAppendingPathComponent:@"company.sqlite"];
    
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];
    
    self.context = context;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (int i=0; i<10; i++) {
        // 创建员工
        Employee *emp1 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.context];
        
        // 设置员工属性
        emp1.name = [NSString stringWithFormat:@"wangwu %d",i];
        emp1.age = @(28 + i);
        emp1.height = @2.10;
        
        // 保存 通过上下文
        NSError *error = nil;
        [self.context save:&error];
        if(!error){
            NSLog(@"success");
        }else{
            NSLog(@"%@",error);
        }

    }
    
}

@end
