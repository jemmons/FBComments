#import "Facebook+Comments.h"

@implementation Facebook (Comments)

-(void)fetchCommentsForURL:(NSURL *)url delegate:(id)aDelegate{
	NSString* fql = [NSString stringWithFormat:@"SELECT post_fbid, fromid, object_id, text, time FROM comment WHERE object_id IN (SELECT comments_fbid FROM link_stat WHERE url ='%@')", url];

	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:fql forKey:@"query"];
	
	[self requestWithMethodName:@"fql.query" andParams:params andHttpMethod:@"GET" andDelegate:aDelegate];
}

@end
