// ----------------------------------------------------------------------
//
//  CAAppDelegate.m
//  ClaimsAdjuster
//
//  Created by Paul Duncanson.
//  Copyright (c) 2012 __Invigorate_Software__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import "CAAppDelegate.h"
#import "XMLParser.h"
//#import "TestFlight.h"

@implementation CAAppDelegate

@synthesize window = _window;
@synthesize listArray;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[TestFlight takeOff:@"241a9a02-951e-4481-b739-ade16ce9d1a7"];
    
    
    //[TestFlight passCheckpoint:@"--didFinishLauchingWithOptions--"];
    // !!!!! Move retrieval of XML data to CATableViewController's ViewDidLoad and
    // !!!!! make use of NSURLConnection to perform internet access asynchronously

    // To access current WIP Claims from UAT Test Portal uncomment following block and 
    // comment out local access used during development
    
    /*
    //----Retrieve current WIP Claims from UI Test Portal-------
    //NSURL *url = [[NSURL alloc] initWithString:@"http://www.topa-portal.com/WIPClaims.xml"];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url]; 
    //----------------------------------------------------------
    */
    
    //----Retrieve WIP Claims test data from local xml file-----
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Claims.xml"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    //-----------------------------------------------------------
    
    NSXMLParser *nsxmlParser = [[NSXMLParser alloc] initWithData:data];
    
    XMLParser *theXMLParser = [[XMLParser alloc] initXMLParser];
    
    [nsxmlParser setDelegate:theXMLParser];
    
    // Verify that XML parsing worked.
    BOOL parseOk = [nsxmlParser parse];
    
    if (parseOk) {
        NSLog(@"WIP Count is %lu", (unsigned long)[listArray count]);
    }
    else {
        NSLog(@"Error while parsing XML data from remote server.");
    }

    [data release];
    [nsxmlParser release];
    [theXMLParser release]; 
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
