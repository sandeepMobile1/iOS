//
//  LatestGroupInvocation.m
//  ConstantLine
//
//  Created by Pramod Sharma on 18/11/13.
//
//

#import "LatestGroupInvocation.h"
#import "JSON.h"
#import "Config.h"

@implementation LatestGroupInvocation

@synthesize user_id,pageString;

-(void)invoke {
	NSString *a= @"latestGroup";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:self.user_id forKey:@"userId"];

    [bodyD setObject:self.pageString forKey:@"page"];

    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
    
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]autorelease]JSONValue];
    NSLog(@"%@",resultsd);
    
	NSError* error = Nil;
	
    NSDictionary *dic=[resultsd objectForKey:@"response"];
    
    if ([dic count]==0) {
        
        moveTabG=FALSE;
    }
    
    [self.delegate LatestGroupInvocationDidFinish:self withResults:dic withMessages:[dic objectForKey:@"error"] withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
  
    moveTabG=FALSE;
    
    [self.delegate LatestGroupInvocationDidFinish:self
                                          withResults:Nil
                                         withMessages:Nil
                                            withError:[NSError errorWithDomain:@"UserId"
                                                                          code:[[self response] statusCode]
                                                                      userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}


@end
