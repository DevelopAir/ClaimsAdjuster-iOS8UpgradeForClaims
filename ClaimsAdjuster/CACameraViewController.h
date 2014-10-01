// ----------------------------------------------------------------------
//
//  CACameraViewController.h
//  ClaimsAdjuster
//
//  Created by Paul Duncanson.
//  Copyright (c) 2012__Invigorate_Software__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import <UIKit/UIKit.h>
#import "AssetsLibrary/AssetsLibrary.h"
#import "CAAppDelegate.h"
#import "WIPList.h"

@interface CACameraViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePicker;
    int iRowSelected;
    NSMutableArray *mArrayOfImages;
}

@property (nonatomic, retain) IBOutlet UIButton *goToSendFromPhotoButton;
@property (nonatomic, retain) CAAppDelegate *app;

-(NSData *)  compressImage:(UIImage *)image;
-(NSData *)  compressImageToTwoHundredFiftyK:(UIImage *)theImage;
-(IBAction)  btnActivateCameraClicked:(id) sender;

@property (retain) IBOutlet UILabel *selectedClaim;
@property (nonatomic, retain) WIPList *theList;

- (id)       init;
- (void)     saveImageName:(NSURL *)assetURL;
- (void)     image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
- (void)     imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)     dealloc;
- (void)     didReceiveMemoryWarning;
@end   
