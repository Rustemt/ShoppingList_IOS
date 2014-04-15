//
//  ItemData.h
//  ShoppingListIOS
//
//  Created by Xiaolong Feng on 8/04/2014.
//  Copyright (c) 2014 XiaolongFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ItemData : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSNumber * price;

@end
