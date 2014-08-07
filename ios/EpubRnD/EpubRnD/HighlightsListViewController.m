//
//  HighlightsListViewController.m
//  EpubRnD
//
//  Created by UdaySravan K on 06/08/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "HighlightsListViewController.h"

@interface HighlightsListViewController ()

@end

@implementation HighlightsListViewController
{
    NSMutableArray *highlightsColl;
    
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
    highlightsColl = [self getAllHighlights];
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
    return highlightsColl.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    HighlightVO *hVO = [highlightsColl objectAtIndex:indexPath.row];
    cell.textLabel.text = hVO.selectedText;
    cell.textLabel.textColor = [UIColor whiteColor];
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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath: */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
    HighlightVO *hVO = [highlightsColl objectAtIndex:indexPath.row];
    
    PageVO *pageVo = [Utils getPageVOUsing:[hVO getChapterIndex] andWordID:[hVO getStartWordID]];
    [self.delegateForPageNav navigateToPage:pageVo];
}
 
 

-(NSMutableArray *) getAllHighlights
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Highlights" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSMutableArray *highlights = [[NSMutableArray alloc] init];
    NSArray *fetchedRecords = [context executeFetchRequest:fetchRequest error:&error];
    if(!error)
    {
        for(NSManagedObject *record in fetchedRecords)
        {
            HighlightVO *highlight = [[HighlightVO alloc] init];
            //        [highlight setObject:[record valueForKey:@"chapterIndex"] forKey:@"chapterIndex"];
            //        [highlight setObject:[record valueForKey:@"highlightedText"] forKey:@"highlightedText"];
            NSString *sWID =[record valueForKey:@"startWordID"];
            NSString *eWID =[record valueForKey:@"endWordID"];
            NSNumber *hasNoteDBValue = [record valueForKey:@"hasNote"];
            NSString *cIndex = [record valueForKey:@"chapterIndex"];
            NSString *text = [record valueForKey:@"highlightedText"];
            NSString *hasNote =[hasNoteDBValue stringValue];
            NSString *moidStr = [[[record objectID] URIRepresentation] absoluteString];
            
            
            [highlight setStartWordID:sWID.integerValue];
            [highlight setEndWordID:eWID.integerValue];
            [highlight setHasNote:hasNote.boolValue];
            [highlight setChapterIndex:cIndex.integerValue];
            [highlight setSelectedText:text];
            [highlight setMoidURIRepresentationString:moidStr];
            
            [highlights addObject:highlight];
        }
        return highlights;
    }
    
    //    NSError *jsonError;
    //    NSArray *temp = [NSArray arrayWithArray:jsonArray];
    //    NSData *data = [NSJSONSerialization dataWithJSONObject:temp options:kNilOptions error:&jsonError];
    //    if(jsonError)
    //    {
    //        NSLog(@"json error : %@",[jsonError localizedDescription]);
    //    }
    //
    //    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //
    //    NSString *send = [NSString stringWithFormat:@"setHighlightsData('%@')",jsonString];
    //
    //
    //    [self stringByEvaluatingJavaScriptFromString:send];
    return nil;
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
    if(highlightsColl)
    {
        [highlightsColl removeAllObjects];
        highlightsColl = nil;
    }
    highlightsColl = [self getAllHighlights];
    [self.tableView reloadData];
}

@end
