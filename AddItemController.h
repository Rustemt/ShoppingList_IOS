//
//  AddItemController.h
//  ShoppingListIOS
//
//  Created by Xiaolong Feng on 8/04/2014.
//  Copyright (c) 2014 XiaolongFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ItemData.h"
#import "Item.h"
#import "ItemCell.h"

@protocol AddItemDelegate <NSObject>

-(void)addItem:(Item*)item;

@end


@interface AddItemController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray* allItems;
@property (weak, nonatomic) id<AddItemDelegate> delegate;


@end
