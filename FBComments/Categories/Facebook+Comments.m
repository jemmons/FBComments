#import "Facebook+Comments.h"

@implementation Facebook (Comments)

-(void)fetchCommentsForURL:(NSURL *)url delegate:(id)aDelegate{
	NSString* fql = [NSString stringWithFormat:@"{\"comments\":\"SELECT post_fbid, fromid, object_id, text, time FROM comment WHERE object_id IN (SELECT comments_fbid FROM link_stat WHERE url ='%@')\", \"users\":\"SELECT name FROM profile WHERE id IN (SELECT fromid FROM #comments)\"}", url];

	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:fql forKey:@"queries"];
	
	[self requestWithMethodName:@"fql.multiquery" andParams:params andHttpMethod:@"GET" andDelegate:aDelegate];
}

@end
