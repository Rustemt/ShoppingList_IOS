//
//  ItemCell.h
//  ShoppingListIOS
//
//  Created by Xiaolong Feng on 8/04/2014.
//  Copyright (c) 2014 XiaolongFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
