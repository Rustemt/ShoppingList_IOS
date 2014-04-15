//
//  ShoppingList.h
//  ShoppingListIOS
//
//  Created by Xiaolong Feng on 8/04/2014.
//  Copyright (c) 2014 XiaolongFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface ShoppingList : NSManagedObject

@property (nonatomic, retain) NSSet *menbers;
@end

@interface ShoppingList (CoreDataGeneratedAccessors)

- (void)addMenbersObject:(Item *)value;
- (void)removeMenbersObject:(Item *)value;
- (void)addMenbers:(NSSet *)values;
- (void)removeMenbers:(NSSet *)values;

@end
