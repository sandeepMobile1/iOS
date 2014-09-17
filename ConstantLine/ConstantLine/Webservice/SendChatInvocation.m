//
//  SendChatInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SendChatInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation SendChatInvocation

@synthesize user_id,friend_id,message,type,imageName,audioName,namecardId,threadId,groupType,groupId,publicPrivateType;

-(void)invoke {
	NSString *a= @"send_chat_data";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    
    NSLog(@"%@",message);
    NSLog(@"%@",groupId);
    NSLog(@"%@",publicPrivateType);
    
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:friend_id forKey:@"friend_id"];
    [bodyD setObject:message forKey:@"message"];    
    [bodyD setObject:type forKey:@"type"];    
    [bodyD setObject:imageName forKey:@"image"];
    [bodyD setObject:namecardId forKey:@"nameCard"];  
    [bodyD setObject:threadId forKey:@"threadId"];  
    [bodyD setObject:groupType forKey:@"group_type"];  
    [bodyD setObject:groupId forKey:@"groupId"];  
    [bodyD setObject:publicPrivateType forKey:@"chatStatus"];


    NSLog(@"Request: %@",[bodyD JSONRepresentation]);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
        
    NSDictionary *dic=[resultsd objectForKey:@"response"];
    
   
	
    [self.delegate SendChatInvocationDidFinish:self withResults:[dic objectForKey:@"success"] withMessages:[dic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate SendChatInvocationDidFinish:self 
                                   withResults:Nil
                                  withMessages:Nil
                                     withError:[NSError errorWithDomain:@"UserId" 
                                                                   code:[[self response] statusCode]
                                                               userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end



