// ----------------------------------------------------------------------
//
//  CATableViewController.m
//  ClaimsAdjuster
//
//  Created by Paul Duncanson.
//  Copyright (c) 2012__Invigorate_Software__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import "CATableViewController.h"
#import "CADetailViewController.h"

@implementation CATableViewController

@synthesize app;
@synthesize detailViewController = _detailViewController;
@synthesize theList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    app = [[UIApplication sharedApplication] delegate];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
 
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
 
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [app.listArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    theList = [app.listArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = theList.name;    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:[NSNumber numberWithInt:(int)indexPath.row] forKey:@"rowSelected"];
        [standardUserDefaults synchronize];
    }
    
    CADetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CADetailViewController"];
    
    detailViewController.theList = [app.listArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES]; 
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
}

- (void)viewDidUnload
{
    [app release];
    [theList release];
    [_detailViewController release];
    [super viewDidUnload];
}

#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    NSLog(@"Received memory use warning in CADetailViewController");
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        
        [app release];
        app = nil;
        
        [theList release];
        theList = nil;
        
        [_detailViewController release];
        _detailViewController = nil;
    }
}

- (void) dealloc
{
    [app release];
    app = nil;
    
    [theList release];
    theList = nil;
    
    [_detailViewController release];
    _detailViewController = nil;
    
    [super dealloc];
}
@end
