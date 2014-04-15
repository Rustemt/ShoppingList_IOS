//
//  ShoppingListControllerTableViewController.h
//  ShoppingListIOS
//
//  Created by Xiaolong Feng on 8/04/2014.
//  Copyright (c) 2014 XiaolongFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ShoppingList.h"
#import "Item.h"
#import "ItemCell.h"
#import "AddItemController.h"

@interface ShoppingListControllerTableViewController : UITableViewController<AddItemDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) ShoppingList * currentList;
@property (strong, nonatomic) NSArray * partyItemList;

-(NSString*)TotalCost;

@end
