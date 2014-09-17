//
//  RevenueViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 11/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKProduct.h>
#import "RevenueInvocation.h"
#import "ConstantLineServices.h"

@interface RevenueViewController : UIViewController <SKProductsRequestDelegate,SKRequestDelegate, SKPaymentTransactionObserver,RevenueInvocationDelegate>
{
    NSArray *arrayProductID;
    IBOutlet UINavigationBar *navigation;
    ConstantLineServices *service;

 
}
@property (nonatomic,retain) NSString *strTransactionId;
@property (nonatomic,retain) NSString *productId;
@property (nonatomic,retain) NSString *productName;
@property (nonatomic,retain) NSString *productPrice;
@property (nonatomic,retain) NSString *groupId;

-(IBAction)btnPurchasePressed:(id)sender;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction:   (SKPaymentTransaction *)transaction;
- (void) restoreTransaction:  (SKPaymentTransaction *)transaction;
- (void) startPurchase;
@end
