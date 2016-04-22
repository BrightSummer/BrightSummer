//
//  Employee+CoreDataProperties.h
//  coredata的简单使用
//
//  Created by ming on 16/4/17.
//  Copyright © 2016年 ming. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Employee.h"

@class Department;

NS_ASSUME_NONNULL_BEGIN

@interface Employee (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) Department *depart;

@end

NS_ASSUME_NONNULL_END
