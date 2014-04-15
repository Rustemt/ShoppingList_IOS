//
//  ShoppingListControllerTableViewController.m
//  ShoppingListIOS
//
//  Created by Xiaolong Feng on 8/04/2014.
//  Copyright (c) 2014 XiaolongFeng. All rights reserved.
//

#import "ShoppingListControllerTableViewController.h"

@interface ShoppingListControllerTableViewController ()

@end

@implementation ShoppingListControllerTableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ShoppingList"];
    
    NSError *error;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(result == nil)
    {
        NSLog(@"Could not fetch Party: \n%@", error.userInfo);
    }
    else if([result count] == 0)
    {
        self.currentList = [NSEntityDescription insertNewObjectForEntityForName:@"ShoppingList" inManagedObjectContext:self.managedObjectContext];
    }
    else
    {
        self.currentList = [result firstObject];
        self.partyItemList = [self.currentList.menbers allObjects];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            return [self.partyItemList count];
        case 1:
            return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        ItemCell *cell = (ItemCell*)[tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
        Item *i = [self.partyItemList objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = i.name;
        cell.descriptionLabel.text = i.descriptions;
        cell.priceLabel.text = [NSString stringWithFormat:@"%@$",i.price];
        
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalCost" forIndexPath:indexPath];
        
        cell.textLabel.text = [self TotalCost];
        
        return cell;
        
    }
    return nil;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.section == 0)
        return YES;
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Item *itemToRemove = [self.partyItemList objectAtIndex:indexPath.row];
        [self.currentList removeMenbersObject:itemToRemove];
        self.partyItemList = [self.currentList.menbers allObjects];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
         
         NSError *error;
         if(![self.managedObjectContext save:&error])
         {
             NSLog(@"Could not save deletion:\n%@",error.userInfo);
         }
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AddItemSegue"])
    {
        AddItemController * controller = segue.destinationViewController;
        controller.managedObjectContext = self.managedObjectContext;
        controller.delegate = self;
    }
}

-(void)addItem:(Item*)item
{
    [self.currentList addMenbersObject:item];
    self.partyItemList = [self.currentList.menbers allObjects];
    [self.tableView reloadData];
    
    NSError *error;
    if(![self.managedObjectContext save:&error])
    {
        NSLog(@"Could not save item insertion:\n%@",error.userInfo);
    }
}

-(NSString*)TotalCost
{
    
    double totalCost = 0;
    for(int i = 0; i < [self.partyItemList count];i++)
    {
        Item *item = [self.partyItemList objectAtIndex:i];
        totalCost += [item.price doubleValue];
    }
    NSString *strTotalCost = [NSString stringWithFormat:@"Total Cost: %.2f$",totalCost];
    return strTotalCost;
}

@end
