新添加了对新浪SSO支持


配置步骤
1.Info.plist添加URL Schemes,schemes为wb+sinapp key的形式

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
        <dict>
            <key>CFBundleTypeRole</key>
	        <string>Editor</string>
	        <key>CFBundleURLName</key>
	        <string>minroad.com</string>
	        <key>CFBundleURLSchemes</key>
	        <array>
		        <string>wb2396343608</string>
	        </array>
        </dict>
    </plist>
    
2.在`- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url`中添加回调

    #import "CHShareManager.h"
    
    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
    {
        if ([[url scheme] isEqualToString:[NSString stringWithFormat:@"wb%@",kWBAppkey]])
        {
            [[CHShareManager mainManager] handleOpenURL:url];
        }
        return YES;
    }

3.CHShareManager.h中修改配置信息

    #define kWBAppkey @"xxxx"    
    #define kWBSecret @"xxx"  
    #define kQQAppkey @"xxx"
    #define kQQSecret @"" //optional

4.修改qq回调地址 
WBAuthorizeWebView.m 

    #define kQQCallback @"qq.com"  

sina无需修改

5.添加Security.framework

6.调用查看WBShareKitViewController.m

    - (IBAction)sinaSend:(id)sender {
        if (![[CHShareManager mainManager] sinaIsVailed]) {
            [[CHShareManager mainManager] showLoginOnViewController:self type:@"sina" finish:@selector(logInDidFinished:) failed:@selector(logInDidFailed:Error:)];
        }
        else{
            [[CHShareManager mainManager] sendWeibo:@"WBShareKit test" image:nil type:@"sina" vc:self finish:@selector(sendDidFinished:) failed:@selector(sendDidError:)];
        }
    }
    
    - (IBAction)qqSend:(id)sender {
        if (![[CHShareManager mainManager] qqIsVailed]) {
            [[CHShareManager mainManager] showLoginOnViewController:self type:@"qq" finish:@selector(logInDidFinished:) failed:@selector(logInDidFailed:error:)];
        }
        else
        {
            [[CHShareManager mainManager] sendWeibo:@"WBShareKit test" image:nil type:@"qq" vc:self finish:@selector(sendDidFinished:) failed:@selector(sendDidError:)];//暂时不支持发送图片，可利用分享api传入image url来实现发送目的。
        }
    }


7.新版WBShareKit只是将 
    [http://qzonestyle.gtimg.cn/qzone/vas/opensns/res/doc/Connect_IOS_SDK__V1.2.zip](http://qzonestyle.gtimg.cn/qzone/vas/opensns/res/doc/Connect_IOS_SDK__V1.2.zip)
与
    [http://code.google.com/p/sinaweibosdkforoauth2/downloads/list](http://code.google.com/p/sinaweibosdkforoauth2/downloads/list)
合并，时间紧凑，代码有些乱，见谅

更多信息

http://www.chlova.com

http://www.minroad.com

