// ----------------------------------------------------------------------
//
//  CADetailViewController.m
//  ClaimsAdjuster
//
//  Created by Paul Duncanson.
//  Copyright (c) 2012__Invigorate_Software__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import "CADetailViewController.h"
#import "CAAppDelegate.h"

@implementation CADetailViewController

@synthesize dolLabel = _dolLabel;
@synthesize goToNotesFromEditButton;
@synthesize dolDate = _dolDate;
  
@synthesize theList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = theList.name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1;
}

- (void)      tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{  
    NSString *strCellIdentifier = [NSString stringWithFormat: @"Cell_%li", (long)indexPath.section];
       
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:strCellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellIdentifier];
		UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 300, 30)];
        textField.borderStyle = UITextBorderStyleNone;
		cell.textLabel.backgroundColor = [UIColor blackColor]; // EXC_BAD_ACCESS error here!!!
        
        // Retrieve the cross reference table index in the textField
        textField.tag = indexPath.section;
        
        // Initialize values from the mutable array
        switch ( indexPath.section ) {
            case 0:
                textField.text = theList.name;
                break;
                
            case 1:
                textField.text = theList.cause;
                break;
                
            case 2:            
                textField.text = theList.dol;
                break;
                
            case 3:     
                textField.text = theList.policy;
                break;
        }
           
		[textField setDelegate:self];
		
		[textField addTarget:self 					 
                      action:@selector(textFieldDone:) 
			forControlEvents:UIControlEventEditingDidEndOnExit];
        
		[cell.contentView addSubview:textField];
		[textField release];

    }
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section 
{
	
	NSString *sectionName = nil;
	
	switch(section)
	{
		case 0:
			sectionName = @"Name";
			break;
		case 1:
			sectionName = @"Cause of Loss";
			break;
		case 2:
			sectionName = @"Date of Loss";
			break;
        case 3:
			sectionName = @"Policy";
			break;
	}
	
	return sectionName;
}		    

#pragma mark - IBActions

-(void)setDol 
{
    dateSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [dateSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
    UIDatePicker *dolPicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    
    [dolPicker setDatePickerMode:UIDatePickerModeDate];
    
    [dateSheet addSubview:dolPicker];
    
    [dolPicker release];
    
    UIToolbar *controlToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,dateSheet.bounds.size.width, 44)];
    
    [controlToolBar setBarStyle:UIBarStyleBlack];
    [controlToolBar sizeToFit];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"Set" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDateSet)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelDateSet)];
    
    [controlToolBar setItems:[NSArray arrayWithObjects:spacer, cancelButton, setButton, nil] animated:NO];
    
    [spacer release];
    [setButton release];
    [cancelButton release];
    
    [dateSheet addSubview:controlToolBar];
    [controlToolBar release];
    
    [dateSheet showInView:self.view];
    
    [dateSheet setBounds:CGRectMake(0,0,320,485)];
}

-(void) cancelDateSet {
    [dateSheet dismissWithClickedButtonIndex:0 animated:YES];
    [dateSheet release];
}

-(void) dismissDateSet {
    NSArray *listOfViews = [dateSheet subviews];
    
    for (UIView *subView in listOfViews) {
        if ([subView isKindOfClass:[UIDatePicker class]]) {
            self.dolDate = [(UIDatePicker *)subView date];
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
  
    
    [dateFormatter release];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *dolCalc = [calendar components:unitFlags 
                                            fromDate:self.dolDate 
                                              toDate:[NSDate date] 
                                             options:0];
    
    int months = (int)[dolCalc month];
    int days = (int)[dolCalc day];
    int years = (int)[dolCalc year];
    
    if (years < 0 || days < 0 || months < 0) {
        [self.dolLabel setText:@"Date of Loss cannot be in the future."];
    } else {
        NSString *output = [NSString stringWithFormat:@"%i year %i month %i day", years, months,days];
        [self.dolLabel setText:output];
    }
    
    [dateSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    [dateSheet release];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField 
{
    switch (textField.tag) {
        case 0:
            self.theList.name = textField.text;
            break;
            
        case 1:
            self.theList.cause = textField.text;
            break;
            
        case 2:
            self.theList.dol = textField.text;
            break;
            
        case 3:
            self.theList.policy = textField.text;
            break;
            
        default:
            NSLog(@"Error in CADetailViewController:textFieldDidEndEditing; received a selected table index value beyond table limit.");
            break;
    }
}

-(IBAction)textFieldDone:(id)sender{	
}

- (void)viewDidUnload {
    [_dolDate release];
    [_dolLabel release];    
    [dateSheet release];
    [theList release];
    [tableView release];
    [goToNotesFromEditButton release];
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

        [_dolDate release];
        _dolDate = nil;
        
        [_dolLabel release];
        _dolLabel = nil;
        
        [dateSheet release];
        dateSheet = nil;
        
        [theList release];
        theList = nil;
        
        [tableView release];
        tableView = nil;
        
        [goToNotesFromEditButton release];

    }
}

- (void) dealloc
{
    [_dolDate release];
    _dolDate = nil;
    
    [_dolLabel release];
    _dolLabel = nil;
    
    [dateSheet release];
    dateSheet = nil;
    
    [theList release];
    theList = nil;
    
    [tableView release];
    tableView = nil;
    
    [goToNotesFromEditButton release];
    [super dealloc];
}


@end

