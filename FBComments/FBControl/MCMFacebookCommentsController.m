#import "MCMFacebookCommentsController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "MCMFacebookCommentsViewController.h"

static const CGFloat kSmallPostHeight = 47.0f;
static const CGFloat kLargePostHeight = 147.0f;

@interface MCMFacebookCommentsController ()
@property (strong) UINavigationController *navigationController;
@property (weak) id sessionDidBecomeClosedObserver;
@property (weak) id sessionDidBecomeOpenObserver;
-(void)expandPost;
-(void)shrinkPost;
-(void)updateConnected:(BOOL)isConnected;
@end

@implementation MCMFacebookCommentsController

-(id)initWithURL:(NSURL *)aURL{
  if((self = [super initWithNibName:@"CommentsView" bundle:nil])){
    MCMFacebookCommentsViewController *aViewController = [[MCMFacebookCommentsViewController alloc] initWithURL:aURL];
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
  
  [self updateConnected:[[FBSession activeSession] isOpen]];
  
  [self setSessionDidBecomeOpenObserver:[[NSNotificationCenter defaultCenter] addObserverForName:FBSessionDidBecomeOpenActiveSessionNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    [self updateConnected:YES];
  }]];

  [self setSessionDidBecomeClosedObserver:[[NSNotificationCenter defaultCenter] addObserverForName:FBSessionDidBecomeClosedActiveSessionNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    [self updateConnected:NO];
  }]];
}


-(void)viewDidUnload{
  [[NSNotificationCenter defaultCenter] removeObserver:[self sessionDidBecomeClosedObserver]];
  [[NSNotificationCenter defaultCenter] removeObserver:[self sessionDidBecomeOpenObserver]];
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


-(void)updateConnected:(BOOL)isConnected{
  if(isConnected){
    [[self connectButton] setHidden:YES];
    [[self postButton] setHidden:NO];
  } else{
    [[self connectButton] setHidden:NO];
    [[self postButton] setHidden:YES];
  }
  
  
}

@end
