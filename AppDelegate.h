//
//  AppDelegate.h
//  ShoppingListIOS
//
//  Created by Xiaolong Feng on 7/04/2014.
//  Copyright (c) 2014 XiaolongFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ShoppingListControllerTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@end
