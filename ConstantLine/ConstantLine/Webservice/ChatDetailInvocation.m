//
//  ChatDetailInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatDetailInvocation.h"
#import "JSON.h"
#import "Config.h"

@implementation ChatDetailInvocation

@synthesize user_id,friend_id,lastMsg_id,type,groupType,groupId,page;

-(void)invoke {
	NSString *a= @"chat_detail";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:self.user_id forKey:@"user_id"];
    [bodyD setObject:self.friend_id forKey:@"friend_id"];
    [bodyD setObject:self.groupType forKey:@"group_type"];
    [bodyD setObject:self.groupId forKey:@"groupId"];
    [bodyD setObject:self.lastMsg_id forKey:@"msgid"];
    [bodyD setObject:self.type forKey:@"type"];
    [bodyD setObject:self.page forKey:@"page"];

    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
   NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *dic=[resultsd objectForKey:@"response"];
    
    if ([dic count]==0) {
        
        moveTabG=FALSE;
    }

	
    [self.delegate ChatDetailInvocationDidFinish:self withResults:[dic objectForKey:@"success"] withMessages:[dic objectForKey:@"error"] withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
   
    moveTabG=FALSE;
	
    [self.delegate ChatDetailInvocationDidFinish:self 
                                   withResults:Nil
                                  withMessages:Nil
                                     withError:[NSError errorWithDomain:@"UserId" 
                                                                   code:[[self response] statusCode]
                                                               userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end



