// ----------------------------------------------------------------------
//
//  CACameraViewController.m
//  ClaimsAdjuster
//
//  Created by Paul Duncanson.
//  Copyright (c) 2012 __Invigorate_Software__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import "CACameraViewController.h"

@implementation CACameraViewController

@synthesize selectedClaim;
@synthesize theList;

- (id) init 
{         
    return self;
}

- (NSData *)compressImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }  
    
    NSData *imageData = UIImageJPEGRepresentation(image, compressionQuality);
    
    return imageData;
}

- (NSData *) compressImageToTwoHundredFiftyK:(UIImage *)theImage
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(theImage, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(theImage, compression);
    }
    return imageData;
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
    //[self.view reloadData];

    self.theList = [self.app.listArray objectAtIndex:iRowSelected];
    
    self.selectedClaim.text = [self.theList.policy stringByAppendingString:@"/"];
    self.selectedClaim.text = [self.selectedClaim.text stringByAppendingString:self.theList.name];
}

-(IBAction)btnActivateCameraClicked:(id) sender
{
	// Create image picker controller
    imagePicker = [[UIImagePickerController alloc] init];
    
	imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
	imagePicker.delegate = self;
        
    // Show image picker
	[self presentViewController:imagePicker animated:NO completion:nil];
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == NULL) 
    {
        // switch to a background thread while compressing image
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *eachCompressedImage = [self compressImageToTwoHundredFiftyK:image];
            if (self.theList.imageNames.length == 0) {
                mArrayOfImages = [[NSMutableArray alloc] init];
            }
            [mArrayOfImages addObject:eachCompressedImage];
            
            NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
            [userDefault setObject:mArrayOfImages forKey:@"ArrayOfImages"];
            
            // switch back to the main thread to provide feedback.
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image successfully saved." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
                [error show];
                [error release];
            });
        });
    }
    else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Image was not saved." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [error show];
        [error release];

    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// Access image from dictionary
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self becomeFirstResponder];
    
	// Close the camera
	[self dismissViewControllerAnimated:NO completion:nil];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    // Request to save the image to camera roll
    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            NSLog(@"writeImageToSavedPhotosAlbum failed");
        } else {
            NSLog(@"url %@", assetURL);
            NSString *filePath= [assetURL absoluteString];
            
            NSLog(@"Image stored at '%@'", filePath);
            
            if (self.theList.imageNames.length > 0) {
                self.theList.imageNames = [self.theList.imageNames stringByAppendingString:@"+"];
                self.theList.imageNames = [self.theList.imageNames stringByAppendingString:filePath];
            }
            else {
                self.theList.imageNames = [[[NSString alloc] initWithString:filePath] autorelease];
                mArrayOfImages = [[NSMutableArray alloc] init];
            }

            NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
            [userDefault setObject:self.theList.imageNames forKey:@"ImageNames"];
            
            // When size matters use the following:
            //NSData *eachCompressedImage = [self compressImageToTwoHundredFiftyK:image];
            
            // When quality matters use the following:
            NSData *eachCompressedImage = [self compressImage:image];

            [mArrayOfImages addObject:eachCompressedImage];
            
            [userDefault setObject:mArrayOfImages forKey:@"ArrayOfImages"];
            
            NSLog(@"imageNames are '%@'", self.theList.imageNames);
        }
    }];
    
    [library release];
}

- (void)saveImageName:(NSURL *)assetURL
{
    NSLog(@"url %@", assetURL);
    NSString *filePath= [assetURL absoluteString];
    NSLog(@"Image stored at '%@'", filePath);
    if (self.theList.imageNames.length > 0) {
        self.theList.imageNames = [self.theList.imageNames stringByAppendingString:@"+"];
    }
    self.theList.imageNames = [self.theList.imageNames stringByAppendingString:filePath];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.theList.imageNames forKey:@"ImageNames"];
}

- (void)viewDidUnload
{
    [imagePicker release];
    [selectedClaim release];

    [super viewDidUnload];
}

#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        [imagePicker release];
        [selectedClaim release];
        self.theList = nil;
    }
}

- (void)dealloc 
{
    [imagePicker release];
    [selectedClaim release];
    [mArrayOfImages release];
    [super dealloc];
}

@end
