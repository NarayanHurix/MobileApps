//
//  BookmarksListViewController.m
//  EpubRnD
//
//  Created by UdaySravan K on 06/08/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "BookmarksListViewController.h"

@interface BookmarksListViewController ()

@end

@implementation BookmarksListViewController
{
    NSMutableArray *bookmarksColl;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    bookmarksColl = [self getAllBookmarks];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return bookmarksColl.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    BookmarkVO *bVO = [bookmarksColl objectAtIndex:indexPath.row];
    cell.textLabel.text = bVO.bookmarkText;
    cell.textLabel.textColor = [UIColor whiteColor];
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    BookmarkVO *bVO = [bookmarksColl objectAtIndex:indexPath.row];
    
    PageVO *pageVo = [Utils getPageVOUsing:bVO->indexOfChapter andWordID:bVO->bookmarkedWordID];
    [self.delegateForPageNav navigateToPage:pageVo];
}
 
 
- (NSMutableArray *) getAllBookmarks
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entitiyDesc = [NSEntityDescription entityForName:@"Bookmarks" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entitiyDesc];
    
    NSError *err ;
    NSArray *records = [context executeFetchRequest:request error:&err];
    NSMutableArray *bookmarks = nil;
    if(!err)
    {
        bookmarks = [[NSMutableArray alloc] init];
        for (NSManagedObject *mObj in records)
        {
            BookmarkVO *bVO = [[BookmarkVO alloc] init];
            bVO->indexOfChapter = [(NSString *)[mObj valueForKey:@"chapter_index"] integerValue];
            bVO->bookmarkedWordID = [(NSString *)[mObj valueForKey:@"word_id"] integerValue];
            [bVO setBookmarkID:[[[mObj objectID] URIRepresentation] absoluteString]];
            [bVO setBookmarkText:[mObj valueForKey:@"text"]];
            [bookmarks addObject:bVO];
        }
    }
    return bookmarks;
}

- (NSManagedObjectContext *) managedObjectContext
{
    NSManagedObjectContext *context = Nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (void) refresh
{
    if(bookmarksColl)
    {
        [bookmarksColl removeAllObjects];
        bookmarksColl = nil;
    }
    bookmarksColl = [self getAllBookmarks];
    [self.tableView reloadData];
}

@end
