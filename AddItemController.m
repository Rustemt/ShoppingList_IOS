//
//  AddItemController.m
//  ShoppingListIOS
//
//  Created by Xiaolong Feng on 8/04/2014.
//  Copyright (c) 2014 XiaolongFeng. All rights reserved.
//

#import "AddItemController.h"

@interface AddItemController ()

@end

@implementation AddItemController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self downloadMonsterData];
}

-(void)downloadMonsterData
{
    double lastUpdate = [self loadLastUpdate];
    
    NSLog(@"Last Update Was: %f", lastUpdate);
    
    NSURL* url;
    if(lastUpdate == -1)
    {
        url = [NSURL URLWithString:@"http://elliott-wilson.com/items/allItems.php"];
    }
    else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://elliott-wilson.com/items/allItems.php?lastChecked=%f",lastUpdate]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
        if(error == nil)
        {
            [self parseItemJSON:data];
            [self fetchItemData];
            [self saveLastUpdate];
        }
        else
        {
            NSLog(@"Connection Error:\n%@",error.userInfo);
                
        }
     }
     ];
    
}

-(void)fetchItemData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"ItemData"];
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[nameSort]];
    
    NSError *error;
    self.allItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(self.allItems == nil)
    {
        NSLog(@"Could not fetch Item Data:\n%@",error.userInfo);
    }
    [self.tableView reloadData];
        
}

-(void)saveLastUpdate
{
    NSDate *currentDate = [NSDate date];
    NSNumber *epochTime = [NSNumber numberWithDouble:[currentDate timeIntervalSince1970]];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:epochTime forKey:@"lastUpdate"];
    NSError *error;
    
    NSData *plist = [NSPropertyListSerialization dataWithPropertyList:dictionary format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"lastUpdate.plist"];
    [plist writeToFile:plistPath atomically:YES];
}

-(double)loadLastUpdate
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *plistPath =[rootPath stringByAppendingPathComponent:@"lastUpdate.plist"];
    NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
    
    if(plistData == nil)
    {
        NSLog(@"No plistData, probably doesn't exist");
        return -1;
    }
    NSError *error;
    
    id plist = [NSPropertyListSerialization propertyListWithData: plistData options: NSPropertyListImmutable format:nil error:&error];
    if(plist == nil)
    {
        NSLog(@"Error opening file:\n%@",error.userInfo);
              return -1;
    }
    
    if([plist isKindOfClass:[NSDictionary class]])
    {
        NSDictionary * dict = (NSDictionary*) plist;
        NSNumber *lastUpdate = [dict valueForKey:@"lastUpdate"];
        return [lastUpdate doubleValue];
    }
    return -1;
}

-(void)parseItemJSON:(NSData*)data
{
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if(result == nil)
    {
        NSLog(@"Error parsing JSON:\n%@", error.userInfo);
        return;
    }
    
    if([result isKindOfClass:[NSArray class]])
    {
        NSArray * itemArray = (NSArray *) result;
        NSLog(@"Found %lu new items!",(unsigned long)[itemArray count]);
        for(NSDictionary * item in itemArray)
        {
            ItemData *itemData = [NSEntityDescription insertNewObjectForEntityForName:@"ItemData" inManagedObjectContext:self.managedObjectContext];
            itemData.name = [item objectForKey:@"name"];
            itemData.descriptions = [item objectForKey:@"description"];
            itemData.price = [item objectForKey:@"price"];
        }
        
        NSError * error;
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"Could not save downloaded monster data:\n%@", error.userInfo);
        }
    }
    else{
        NSLog(@"Unexpected JSON format");
        return;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.allItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ItemCell";
    ItemCell *cell = (ItemCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ItemData *i = [self.allItems objectAtIndex:indexPath.row];
    cell.nameLabel.text = i.name;
    cell.descriptionLabel.text = i.descriptions;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@$",[i.price stringValue]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemData * selectedItem = [self.allItems objectAtIndex:indexPath.row];
    Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    
    newItem.name = selectedItem.name;
    newItem.descriptions = selectedItem.descriptions;
    newItem.price = selectedItem.price;
    [self.delegate addItem:newItem];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
