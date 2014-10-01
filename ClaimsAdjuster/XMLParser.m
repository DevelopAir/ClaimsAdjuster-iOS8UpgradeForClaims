// ----------------------------------------------------------------------
//
//  XMLParser.m
//  ClaimsAdjuster
//
//  Created by Paul Duncanson on 2/28/12.
//  Copyright (c) 2012__Invigorate_Software_For_Topa_Insurance__. All rights reserved.
//
// Rev. History:
//
// ----------------------------------------------------------------------

#import "XMLParser.h"

@implementation XMLParser

-(id) initXMLParser {
    
    if (self == [super init]) {
        
        app = (CAAppDelegate *)[[UIApplication sharedApplication]delegate];
        
    }
    return self;
}

-(void) parser:(NSXMLParser *)parser didStartElement:
    (NSString *)elementName namespaceURI:
    (NSString *)namespaceURI qualifiedName:
    (NSString *)qName attributes:
    (NSDictionary *)attributeDict{
    
    NSString *fieldName;
    
    if ([elementName isEqualToString:@"Claims"]) {
        
        app.listArray = [[NSMutableArray alloc] init];
    }
    else if([elementName isEqualToString:@"List" ] ){
        
        theList = [[WIPList alloc] init];
        
        theList.listID = [[attributeDict objectForKey:@"id"] integerValue];
        
    }
    else {
        
        fieldName = [attributeDict objectForKey:@"fieldName"];
        
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        
        NSString *fieldNameValue = [userDefault objectForKey:[@"fn_" stringByAppendingString:elementName]];
        if (fieldNameValue == nil) {
            [userDefault setObject:fieldName forKey:[@"fn_" stringByAppendingString:elementName]];
        }
    }
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (!currentElementValue) {
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    }
    else
        [currentElementValue appendString:string];
}

-(void) parser:(NSXMLParser *)parser didEndElement:
    (NSString *)elementName namespaceURI:
    (NSString *)namespaceURI qualifiedName:
    (NSString *)qName{
    
    if ([elementName isEqualToString:@"Claims"]) {

        return;
    }
    
    if ([elementName isEqualToString:@"List"]) {
        [app.listArray addObject:theList];
        
        theList = nil;
        
    }
    else 
        [theList setValue:currentElementValue forKey:elementName];
    
    currentElementValue = nil;
    
}

@end
