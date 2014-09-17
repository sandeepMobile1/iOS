//
//  QuitSpecialGroupInvocation.m
//  ConstantLine
//
//  Created by Shweta Sharma on 11/07/14.
//
//

#import "QuitSpecialGroupInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation QuitSpecialGroupInvocation

@synthesize user_id,group_id,type,owner_id;

-(void)invoke {
	NSString *a= @"groupQuitfromSpecialGroup";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    [bodyD setObject:self.user_id forKey:@"userId"];
    [bodyD setObject:self.owner_id forKey:@"ownerId"];
    [bodyD setObject:self.group_id forKey:@"groupId"];
    [bodyD setObject:self.type forKey:@"owner"];
    
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *responseDic=[resultsd objectForKey:@"response"];
    
	
    [self.delegate QuitSpecialGroupInvocationDidFinish:self withResults:[responseDic objectForKey:@"success"] withMessages:[responseDic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate QuitSpecialGroupInvocationDidFinish:self
                                    withResults:Nil
                                   withMessages:Nil
                                      withError:[NSError errorWithDomain:@"UserId"
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
