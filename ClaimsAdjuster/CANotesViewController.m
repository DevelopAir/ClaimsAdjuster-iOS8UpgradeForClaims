// ----------------------------------------------------------------------
//
//  CANotesViewController.m
//  ClaimsAdjuster
//
//  Created by Paul Duncanson.
//  Copyright (c) 2012 __Invigorate_Software__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import "CANotesViewController.h"

@interface CANotesViewController ()

@end

@implementation CANotesViewController

@synthesize claimNote;
@synthesize goToPhotoFromNotesButton;
@synthesize theList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.claimNote.text = self.theList.notes;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rowSelected = nil;
    
    if (standardUserDefaults)
        rowSelected = [standardUserDefaults objectForKey:@"rowSelected"];
    
    iRowSelected = [rowSelected intValue];
    
    self.app = [[UIApplication sharedApplication] delegate];
    
    self.theList = [self.app.listArray objectAtIndex:iRowSelected];
    
    claimNote.delegate = self;
    
    [self.view addSubview:claimNote];   
    
    self.claimNote.text = self.theList.notes;
    
    self.claimId.text = [self.theList.policy stringByAppendingString:@"/"];
    self.claimId.text = [self.claimId.text stringByAppendingString:self.theList.name];
    
    bTextChanged = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)textViewDidChange:(UITextView *)textView
{
    bTextChanged = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (bTextChanged == YES)
    {
      self.theList.notes = self.claimNote.text;
    
      [self.app.listArray replaceObjectAtIndex:iRowSelected withObject:self.theList];
    }
}

- (void)viewDidUnload
{
    [self setClaimNote:nil];
    [self setGoToPhotoFromNotesButton:nil];
    self.theList = nil;
    [super viewDidUnload];
}

#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        [claimNote release];
        claimNote = nil;
        [goToPhotoFromNotesButton release];
        goToPhotoFromNotesButton = nil;
        self.theList = nil;
    }
}

- (void)dealloc {
    [claimNote release];
    [goToPhotoFromNotesButton release];
    [_claimId release];
    [super dealloc];
}

@end
