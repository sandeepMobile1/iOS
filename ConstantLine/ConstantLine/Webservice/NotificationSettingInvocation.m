//
//  NotificationSettingInvocation.m
//  ConstantLine
//
//  Created by Shweta Sharma on 10/02/14.
//
//

#import "NotificationSettingInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation NotificationSettingInvocation

@synthesize user_id,notificationStatus;

-(void)invoke {
	NSString *a= @"updateNotification";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:self.user_id forKey:@"userId"];
    [bodyD setObject:self.notificationStatus forKey:@"notification"];
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *responseDic=[resultsd objectForKey:@"response"];
	
    [self.delegate NotificationSettingInvocationDidFinish:self withResults:[responseDic objectForKey:@"success"] withMessages:[responseDic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate NotificationSettingInvocationDidFinish:self
                                    withResults:Nil
                                   withMessages:Nil
                                      withError:[NSError errorWithDomain:@"UserId"
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}
@end
