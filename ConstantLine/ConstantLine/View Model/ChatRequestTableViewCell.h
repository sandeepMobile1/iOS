

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@class  ChatRequestTableViewCell;

@protocol ChatRequestTableViewCellDelegate <NSObject>

@optional

-(void) ChatRquestButtonClick:(ChatRequestTableViewCell*)cellValue;
-(void) ChatRequestProfileClick:(ChatRequestTableViewCell*)cellValue;
-(void) buttonAcceptClick:(ChatRequestTableViewCell*)cellValue;
-(void) buttonRejectClick:(ChatRequestTableViewCell*)cellValue;
-(void) buttonRequestClick:(ChatRequestTableViewCell*)cellValue;


@end

@interface ChatRequestTableViewCell :UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIButton *btnChatMessage;
@property(nonatomic,strong)IBOutlet UIButton *btnProfileImage;

@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UILabel *lblMessage;

@property(nonatomic,strong)IBOutlet UIButton *btnAccept;
@property(nonatomic,strong)IBOutlet UIButton *btnReject;

@property (nonatomic, unsafe_unretained) id<ChatRequestTableViewCellDelegate> cellDelegate;

+(ChatRequestTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnChatMessagePressed:(id)sender;
-(IBAction)btnProfileImagePressed:(id)sender;
-(IBAction)btnAcceptPressed:(id)sender;
-(IBAction)btnRejectPressed:(id)sender;
-(IBAction)btnRequestPressed:(id)sender;

@end

