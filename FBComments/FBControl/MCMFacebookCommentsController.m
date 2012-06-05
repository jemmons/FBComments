#import "MCMFacebookCommentsController.h"

#import "Facebook.h"
#import "MCMFacebookCommentsViewController.h"

static const CGFloat kSmallPostHeight = 47.0f;
static const CGFloat kLargePostHeight = 147.0f;

@interface MCMFacebookCommentsController ()
@property (strong) UINavigationController *navigationController;
-(void)expandPost;
-(void)shrinkPost;
@end

@implementation MCMFacebookCommentsController
@synthesize textView, postView;
@synthesize navigationController;

-(id)initWithURL:(NSURL *)aURL andFacebookObject:(Facebook *)aFacebookObject{
  if((self = [super initWithNibName:@"CommentsView" bundle:nil])){
    MCMFacebookCommentsViewController *aViewController = [[MCMFacebookCommentsViewController alloc] initWithURL:aURL andFacebook:aFacebookObject];
    UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:aViewController];
    [aNavigationController setDelegate:self];
    [self setNavigationController:aNavigationController];
  }
  return self;
}


-(void)viewDidLoad{
  [super viewDidLoad];
  [[self textView] setDelegate:self];
  
  [[self view] setClipsToBounds:YES];
  CGRect bounds = [[self view] bounds];
  bounds.size.height -= kSmallPostHeight;
  [[[self navigationController] view] setFrame:bounds];
  [[self view] insertSubview:[[self navigationController] view] belowSubview:[self postView]];
}


-(void)viewDidUnload{
  [[self textView] setDelegate:nil];
  [super viewDidUnload];
}


-(void)dealloc{
  [[self navigationController] setDelegate:nil];
}


-(void)navigationController:(UINavigationController *)aNavigationController willShowViewController:(UIViewController *)aViewController animated:(BOOL)isAnimated{
  if(aNavigationController == [self navigationController]){
    if(aViewController == [[aNavigationController viewControllers] objectAtIndex:0]){
      [aNavigationController setNavigationBarHidden:YES animated:isAnimated];
    } else{
      [aNavigationController setNavigationBarHidden:NO animated:isAnimated];    
    }
  }
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  return YES;
}


#pragma mark - TEXT VIEW DELEGATE
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
  [self expandPost];
  return YES;
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
  [self shrinkPost];
  return YES;
}


#pragma mark - PRIVATE
-(void)shrinkPost{
  CGRect frame = [[self postView] frame];
  frame.origin.y = CGRectGetMaxY(frame)-kSmallPostHeight;
  frame.size.height = kSmallPostHeight;
  [[self postView] setFrame:frame];
}


-(void)expandPost{
  CGRect frame = [[self postView] frame];
  NSLog(@"view: %@", [self postView]);
  NSLog(@"frame %@", NSStringFromCGRect(frame));
  frame.origin.y = CGRectGetMaxY(frame) - kLargePostHeight;
  frame.size.height = kLargePostHeight;
  [[self postView] setFrame:frame];
}


@end
