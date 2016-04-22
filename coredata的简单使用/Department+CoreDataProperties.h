//
//  Department+CoreDataProperties.h
//  coredata的简单使用
//
//  Created by ming on 16/4/17.
//  Copyright © 2016年 ming. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Department.h"

NS_ASSUME_NONNULL_BEGIN

@interface Department (CoreDataProperties)

// 部门名称
@property (nullable, nonatomic, retain) NSString *name;

// 部门成立日期
@property (nullable, nonatomic, retain) NSDate *createDate;

// 部门编号
@property (nullable, nonatomic, retain) NSString *departNo;

@end

NS_ASSUME_NONNULL_END
