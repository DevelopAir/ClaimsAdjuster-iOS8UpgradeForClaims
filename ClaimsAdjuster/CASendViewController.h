// ----------------------------------------------------------------------
//
//  CASendViewController.h
//  ClaimsAdjuster
//
//  Created by Paul Duncanson.
//  Copyright (c) 2012 __Invigorate_Software__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CAAppDelegate.h"
#import "WIPList.h"

@interface CASendViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    int iRowSelected;
    NSString *formatSubject;
    NSInteger mUnfinishedRequests;
    NSMutableArray *mArrayOfImages;
}

typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);

typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

- (IBAction)sendEmail:(id)sender;

-(NSData *) compressImageToTwoHundredFiftyK:(UIImage *)theImage;

@property (retain) IBOutlet UILabel *selectedClaim;

@property (nonatomic, retain) WIPList *theList;

@property (nonatomic, retain) CAAppDelegate *app;

@end
