#import "MCMFacebookCommentsController.h"

#import "MCMFacebookCommentsViewController.h"

@interface MCMFacebookCommentsController ()
@end

@implementation MCMFacebookCommentsController

+(id)commentsController{
  MCMFacebookCommentsViewController *aViewController = [[MCMFacebookCommentsViewController alloc] init];
  MCMFacebookCommentsController *commentsController = [[MCMFacebookCommentsController alloc] initWithRootViewController:aViewController];
  return commentsController;
}

-(void)viewDidLoad{
  [super viewDidLoad];
}


-(void)viewDidUnload{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  return YES;
}

@end
