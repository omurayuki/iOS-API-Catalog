# iOS13_APIs

### _※iOS13(定期更新中)_  

※基本的な動作確認方法など

GIFはAUTO*480 EZGIFサイト

## Vision(Text Recognition)

![mojininnsiki](https://user-images.githubusercontent.com/46431586/68022429-9b05bc00-fce7-11e9-8337-fa71db61583a.gif)

> 概要:  
・文字の領域を識別  
・文字認識  
>  
>※英数字の識別しか現状できない

> 技術資料:  
[How to use VNRecognizeTextRequest’s optical character recognition to detect text in an image](https://www.hackingwithswift.com/example-code/vision/how-to-use-vnrecognizetextrequests-optical-character-recognition-to-detect-text-in-an-image)  
[Text recognition on iOS 13 with Vision, SwiftUI and Combine](https://martinmitrevski.com/2019/06/16/text-recognition-on-ios-13-with-vision-swiftui-and-combine/)

> サンプルコード:  
[ScanningDocuments](https://github.com/julianschiavo/blog-example-code/tree/master/2019-06-15-ScanningDocuments)  

> Apple Document:  
https://developer.apple.com/documentation/vision

## VisionKit

![Vision](https://user-images.githubusercontent.com/46431586/68005518-e05ec500-fcb8-11e9-802d-4f732efee9df.gif)

> 概要:  
・iOS13からNotesアプリに搭載されるOCRの機能を提供(文字認識)  
・ドキュメントスキャン  
・ドキュメント編集  

> 技術資料:  
[VisionKitBasics](https://qiita.com/kokoheia/items/1e5a7980d7a46cacb209)  
[Scanning documents with Vision and VisionKit on iOS 13](https://schiavo.me/2019/scanning-documents/)  

> サンプルコード:  
[VisionKit-Example](https://github.com/gbmksquare/VisionKit-Example)  

> ライブラリ:  
> [WeScan](https://github.com/WeTransfer/WeScan)  

> Apple Document:  
https://developer.apple.com/documentation/visionkit  
https://developer.apple.com/documentation/visionkit/vndocumentcameraviewcontrollerdelegate

## Core NFC
![coreNFC](https://user-images.githubusercontent.com/39009922/68223032-60758980-002f-11ea-8fb2-559f9c451b69.gif)

> 概要:  
> ・NFCタグ直接読み取り/書き込み(システムコード指定、暗号化通信可)  
> ・カード固有IDの読み出し  
> ・高機能/複雑な構造を持ったカード・タグの取り扱い  
> ・交通系電子マネーの履歴読み取り  
> ・会員カードの読み取り  
> ・NDEFタグの作成・書き換え  
> ・フィットネス機器などとの双方向の通信  
> ・各種機器の設定  
> ・各種機器のそれなりの容量のデータの読み取り
>   
> ※※ FeliCa Plug, FeliCa Linkその他など

> 技術資料:  
> [iPhoneでFeliCaを読み取ってみた](https://speakerdeck.com/tattn/iphonedefelicawodu-miqu-tutemita?slide=5)  
> [iOS13 CoreNFCの使いみちとQRコード、BLEとの比較](https://qiita.com/gpsnmeajp/items/88e61086902a8a9bdaa4)  

> サンプルコード:  
> [vCardCoreNFCWriter](https://github.com/alfianlosari/vCardCoreNFCWriter)

> ライブラリ:  
> [TRETJapanNFCReader](https://github.com/treastrain/TRETJapanNFCReader)  

> Apple Document:  
https://developer.apple.com/documentation/corenfc

## Portrait Effects Matte
<img width="450" src="https://user-images.githubusercontent.com/39009922/68223058-6c614b80-002f-11ea-8e2e-0600ab35794b.png" />

> 概要:  
・人物の矩形を背景から切り抜き  
・人物の矩形と背景の深度測定  
・AR表現における回り込み  
>  
> ※現状静止画のみ  
> ※人物のみ  

> 技術資料:  
[iOS 12のPortrait Matteがすごい／ #iOSDC 2018で登壇します](http://shu223.hatenablog.com/entry/2018/08/22/200226)  

> サンプルコード:  
> [PortraitEffectsMatteSample](https://github.com/kentat01/PortraitEffectsMatteSample/tree/master/PortraitEffectsMatteSample)

> Apple Document:  
https://developer.apple.com/documentation/avfoundation/avportraiteffectsmatte

## Semantic Segmentation Matte

<img width="450" src="https://user-images.githubusercontent.com/46431586/68005658-4fd4b480-fcb9-11e9-800b-c6d109cf0387.jpg" />

> 概要:  
・人物の"髪", "肌", "歯"をセグメンテーションする  
>  
> ※現状静止画のみ  
> ※人物のみ  

> 技術資料:  
[Multi-cam support in iOS 13 allows simultaneous video, photo, and audio capture](https://9to5mac.com/2019/06/07/multi-cam-support-ios13/)  
[セマンティック・セグメンテーションの基礎](https://jp.mathworks.com/content/dam/mathworks/mathworks-dot-com/company/events/webinar-cta/2459280_Basics_of_semantic_segmentation.pdf)  
[iOS 13のSemantic Segmentation Matte(有料)](https://note.mu/shu223/n/nf44027919ad4)  

> Apple Document:  
https://developer.apple.com/documentation/avfoundation/avsemanticsegmentationmatte?language=objc

> 補足:  
Portrait Effects Matteと同様の方法でImageDataを操作するが、用意されているメソッドでは今の所実装出来なかった(動かなかった)。 
Semantic Segmentation Matteの実装資料も見当たらない。 
またApple公式でもSemantic Segmentation Matteの実装について言及している資料が見当たらない。

## Core Haptic
<img width="450" src="https://user-images.githubusercontent.com/46431586/68066465-ef5a7b80-fd7b-11e9-8fad-812ae63b4af5.jpg" />

> 概要:  
・デバイスの振動制御が可能  
・細かな振動制御まで可能

> 技術資料:  
[iOS13で公開予定の「Core Haptics」を使って、Haptic Feedback (触覚フィードバック) するコードを書いてみた](https://tech.showroom.co.jp/entry/2019/07/10/191930)  

> Apple Document:  
https://developer.apple.com/documentation/corehaptics

## デプス推定(Apple提供機械学習モデル使用)
![today](https://user-images.githubusercontent.com/39009922/68222674-b85fc080-002e-11ea-99f8-551d11973736.gif)

> 概要:  
・iOS11以上であればどのデバイスでも測定可能
・静止画でも動画でも測定可能
・Portrait Effects MatteやSemantic Segmentation Matteなど、iOS13以降の標準APIよりかは精度は荒い印象(学習モデルが強化されたら今後の期待大)

> 技術資料:  
[DepthPrediction-CoreML](https://github.com/tucan9389/DepthPrediction-CoreML/tree/master/DepthPrediction-CoreML)

> Apple Document:  
https://developer.apple.com/jp/machine-learning/models/
