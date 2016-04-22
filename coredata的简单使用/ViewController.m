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
#import "Status.h"
#import "Department.h"

@interface ViewController ()
@property(strong,nonatomic) NSManagedObjectContext *companyContext;
@property(strong,nonatomic) NSManagedObjectContext *weiboContext;
@end

@implementation ViewController


#pragma mark 添加员工和微博信息
- (IBAction)addEmployee:(id)sender {
    // 添加员工信息
    
    Employee *emp = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.companyContext];
    emp.name = @"zhangsan";
    emp.height = @1.8;
    emp.age = @25;
    
    [self.companyContext save:nil];
    
    Status *sts = [NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:self.weiboContext];
    
    sts.text = @"微博内容";
    sts.author = @"ming";
    sts.createDate = [NSDate date];
    
    [self.weiboContext save:nil];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 创建 Company 的上下文
    self.companyContext = [self setupContextWithModelName:@"Company"];
    // 创建 Weibo 的上下文
    self.weiboContext = [self setupContextWithModelName:@"Weibo"];
    
}
/**
 *  根据模型文件名返回上下文
 *
 *  @param modelName ;
 *
 *  @return <#return value description#>
 */
- (NSManagedObjectContext *) setupContextWithModelName:(NSString *)modelName{
    // 上下文 关联Company.xcdatamodeld 模型文件
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    
    // 关联模型文件
    
    // 创建一个模型对象
    // 传一个nil 会把 bundle 下的所有模型关联起来
    // 查找 model 文件的 URL
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // 持久化存储调度器
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 存储数据库的名字
    NSError *error = nil;
    
    // 获取 doc 目录
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 数据库保存的路径
    NSString *sqlitePath = [doc stringByAppendingFormat:@"/%@.sqlite",modelName];
    
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];
    
    context.persistentStoreCoordinator = store;
    
    return context;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
