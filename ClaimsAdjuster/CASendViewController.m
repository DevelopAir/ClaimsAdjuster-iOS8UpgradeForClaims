 // ----------------------------------------------------------------------
//
//  CASendViewController.m
//  ClaimsAdjuster
//
//  Created by Paul Duncanson.
//  Copyright (c) 2012 __Invigorate_Software__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import "CASendViewController.h"
//#import "TestFlight.h"
      
@interface CASendViewController()

@end

@implementation CASendViewController

@synthesize theList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[TestFlight passCheckpoint:@"--sendViewController--"];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rowSelected = nil;
    
    if (standardUserDefaults)
        rowSelected = [standardUserDefaults objectForKey:@"rowSelected"];
    
    iRowSelected = [rowSelected intValue];
    
    self.app = [[UIApplication sharedApplication] delegate];
    
    self.theList = [self.app.listArray objectAtIndex:iRowSelected];
    
    self.selectedClaim.text = [self.theList.policy stringByAppendingString:@"/"];
    self.selectedClaim.text = [self.selectedClaim.text stringByAppendingString:self.theList.name];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (void)sendReportReport
{
}

- (IBAction)sendEmail:(id)sender {
    
    MFMailComposeViewController *email;
    NSString *formatEmailBody;
    
    if ([MFMailComposeViewController canSendMail]) {
        
        //[TestFlight passCheckpoint:@"--sendEmail--"];
            
        email = [[[MFMailComposeViewController alloc] init] autorelease];
            
        email.mailComposeDelegate = self;
            
        // Initialize recipient, subject and body of email.
        [email setToRecipients:[NSArray arrayWithObjects:self.theList.toAddress, nil]];
        formatSubject = [self.theList.policy stringByAppendingString:@"/"];
        formatSubject = [formatSubject stringByAppendingString:self.theList.name];
        [email setSubject:formatSubject];
        
        formatEmailBody = [NSString stringWithFormat: @"%@ %@\n",  @"Claimant:", self.theList.name];
        formatEmailBody = [formatEmailBody stringByAppendingString:
                           [NSString stringWithFormat: @"%@ %@\n", @"Policy:", self.theList.policy]];
        formatEmailBody = [formatEmailBody stringByAppendingString:
                           [NSString stringWithFormat: @"%@ %@\n", @"Cause:", self.theList.cause]];
        formatEmailBody = [formatEmailBody stringByAppendingString:
                           [NSString stringWithFormat: @"%@ %@\n", @"DOL:", self.theList.dol]];
        formatEmailBody = [formatEmailBody stringByAppendingString:
                           [NSString stringWithFormat: @"%@ %@\n", @"PremCodes:", self.theList.premCodes]];
        formatEmailBody = [formatEmailBody stringByAppendingString:
                           [NSString stringWithFormat: @"%@%@\n",  @"Notes:\n", self.theList.notes]];
        
        [email setMessageBody:formatEmailBody isHTML:NO];
            
        // attach images
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        mArrayOfImages = [userDefault objectForKey:@"ArrayOfImages"];
        NSString *imageNames = [userDefault objectForKey:@"ImageNames"];
        NSArray *arrayOfImageNames = [imageNames componentsSeparatedByString:@"+"];
            
        for (int i = 0; i < mArrayOfImages.count; i++)
        {
            [email addAttachmentData:mArrayOfImages[i] mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@", arrayOfImageNames[i]]];
        }
        
        // Display mail view controller
        [self presentViewController:email animated:YES completion:NULL];
    }
    
    else {
        
        NSLog(@"Setting up an email account using your device Settings is required.");
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [theList release];
    theList = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        [theList release];
        theList = nil;
    }
}

- (void)dealloc {
    [theList release];
    [super dealloc];
}

@end
