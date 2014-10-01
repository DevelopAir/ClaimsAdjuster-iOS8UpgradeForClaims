// ----------------------------------------------------------------------
//
//  CANotesViewController.h
//  ClaimsAdjuster
//
//  Created by Paul Duncanson.
//  Copyright (c) 2012 __Invigorate_Software__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import <UIKit/UIKit.h>
#import "CAAppDelegate.h"
#import "WIPList.h"

@interface CANotesViewController : UIViewController <UITextViewDelegate>
{
    int iRowSelected;
    Boolean bTextChanged;
}
@property (retain, nonatomic) IBOutlet UILabel *claimId;

@property (retain, nonatomic) IBOutlet UITextView *claimNote;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *goToPhotoFromNotesButton;

@property (nonatomic, retain) WIPList *theList;

@property (nonatomic, retain) CAAppDelegate *app;

@end
