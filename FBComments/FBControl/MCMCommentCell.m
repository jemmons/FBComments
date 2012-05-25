#import "MCMCommentCell.h"

@implementation MCMCommentCell
@synthesize containerView, comment, name, image, indented;

-(void)setIndented:(BOOL)isIndented{
  indented = isIndented;

  CGRect frame = [[self contentView] frame];
  frame.size.width -= 10.0f; //a little margin to stop it from running into the end of the cell.
  if(isIndented){
    frame.origin.x = 20.0f;
    frame.size.width -= 20.0f;
  }
  [[self containerView] setFrame:frame];
}
@end
