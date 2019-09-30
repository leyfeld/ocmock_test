//
//  Server.m
//  server_client
//
//  Created by Anna Vorobiova on 6/28/19.
//  Copyright © 2019 Anna Vorobiova. All rights reserved.
//

#import "Server.h"

@implementation Server

-(NSString*)getData:(NSError **)error
{
    
   return @"{\n"
    "    \"array\": [\n"
    "        {\n"
    "            \"name\": \"Vasya\",\n"
    "            \"type\": 1,\n"
    "            \"pets\": [\n"
    "                \"sharik\",\n"
    "                \"tuzik\"\n"
    "            ]\n"
    "        },\n"
    "        {\n"
    "            \"name\": \"Anna\",\n"
    "            \"type\": 2\n"
    "        }\n"
    "    ]\n"
    "}";
}
-(NSError*)postData:(NSString*)data
{
    NSError* error = [[NSError alloc] init];
    return error;
}

@end
