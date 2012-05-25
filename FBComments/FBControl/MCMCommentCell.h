@interface MCMCommentCell : UITableViewCell
@property (weak) IBOutlet UIView *containerView;
@property (weak) IBOutlet UILabel *comment;
@property (weak) IBOutlet UILabel *name;
@property (weak) IBOutlet UIImageView *image;
@property (nonatomic, getter = isIndented) BOOL indented;
@end
