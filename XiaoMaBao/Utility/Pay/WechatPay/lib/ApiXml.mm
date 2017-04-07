
#import <Foundation/Foundation.h>
#import "ApiXml.h"
/*
 XML 解析库
 */
@implementation XMLHelper
-(void) startParse:(NSData *)data{

    dictionary =[NSMutableDictionary dictionary];
    contentString=[NSMutableString string];
    
    //Demo XML解析实例
    xmlElements = [[NSMutableArray alloc] init];
    
    xmlParser = [[NSXMLParser alloc] initWithData:data];

    [xmlParser setDelegate:self];
    [xmlParser parse];
    
}
-(NSMutableDictionary*) getDict{
    return dictionary;
}
//解析文档开始
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    //MMLog(@"解析文档开始");
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //MMLog(@"遇到启始标签:%@",elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //MMLog(@"遇到内容:%@",string);
    [contentString setString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //MMLog(@"遇到结束标签:%@",elementName);
    
    if( ![contentString isEqualToString:@"\n"] && ![elementName isEqualToString:@"root"]){
        [dictionary setObject: [contentString copy] forKey:elementName];
        //MMLog(@"%@=%@",elementName, contentString);
    }
}

//解析文档结束


@end