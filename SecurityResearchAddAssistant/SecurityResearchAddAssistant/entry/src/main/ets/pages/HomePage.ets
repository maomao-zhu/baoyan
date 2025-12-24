import { router } from "@kit.ArkUI"

@Entry
@Component
export struct HomePage {

  build() {
    Column() {
      Column(){
        //坐标
        Row({space:5}){
          Image($r('app.media.zuobiao'))
            .width(13)
          Text('福建')
            .fontSize(13)
        }
        .justifyContent(FlexAlign.Start)
        .padding({left:15,top:3})
        .width('100%')

        //搜搜狂
        Row({space:5}){
          Search({value:'如何做到高效加分',placeholder:'如何做到高效加分'})
            .fontColor('#ccc')
            .textFont({size:12,style:FontStyle.Normal})
            .height(35)
            .placeholderFont({size:7,family:null,style:FontStyle.Italic})//设置placeholder文本样式，包括字体大小，字体粗细，字体族，字体风格。当前支持'HarmonyOS Sans'字体和注册自定义字体。
            .searchIcon({size:25,color:Color.Orange,src:'/image/huo.svg'})//设置左侧搜索图标样式。
            .cancelButton({style:CancelButtonStyle.INPUT,icon:{size:18,color:Color.Blue,src:'/image/sous.svg'}})//设置右侧清除按钮样式。
            .layoutWeight(1)
          Image($r('app.media.shaomiao'))
            .width(20)
        }
        .margin({top:5})
        .padding({left:15,right:15})
        .height(40)
        .width('100%')


        // 轮播图
        Row(){
          Swiper() {
            Image($r('app.media.swiimage'))
              .width(320)
              .height(140)
              .borderRadius(13)
            Image($r('app.media.swiimage'))
              .width(320)
              .height(140)
              .borderRadius(13)
            Image($r('app.media.swiimage'))
              .width(320)
              .height(140)
              .borderRadius(13)

          }
          .indicator(true)
          .loop(true)
          .autoPlay(true)
          .interval(3000)
          .width('100%')
          .height(150)
          .margin({ top: 8, bottom: 16 })
        }
        .padding({left:15,right:15})
        .width('100%')
      }
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [["#70a6ff", 0], ["#f1f1f1", 1]]
      })
      .height(250)
      .width('100%')

      Column(){
        Scroll(){
          Column(){
            Row(){
              Column({space:8}){
                Image($r('app.media.tushu'))
                  .width(50)
                Text('学科竞赛')
                  .fontSize(12)
              }
              .width(50)
              .onClick(()=>{
                  router.pushUrl({
                    url:'pages/XueKeJIngSaiPage'
                  })
              })
              Column({space:8}){
                Image($r('app.media.keyanchengguo'))
                  .width(50)
                Text('科研成果')
                  .fontSize(12)
              }
              .width(50)
              Column({space:8}){
                Image($r('app.media.chuangxinchuangye'))
                  .width(50)
                Text('创新创业')
                  .fontSize(12)
              }
              .width(50)
              Column({space:8}){
                Image($r('app.media.shehuishijian'))
                  .width(50)
                Text('社会实践')
                  .fontSize(12)
              }
              .onClick(()=>{
                router.pushUrl({
                  url:'pages/SheHuiShiJianPage'
                })
              })
              .width(50)
            }
            .backgroundColor('#f1f1f1')
            .padding({left:25,right:25})
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')

            //热门活动
            Row(){
              Text('热门活动')
                .fontWeight(700)
              Row(){
                Text('查看更多')
                  .fontSize(12)
                  .fontColor('#4e8ef4')
                Image($r('app.media.jinru'))
                  .fillColor('#4e8ef4')
                  .width(15)
              }
            }
            .margin({top:15,bottom:10})
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
            .backgroundColor('#f1f1f1')
            .padding({left:15,right:15})
            .width('100%')




            Row(){

              Scroll(){
                Row({space:20}){
                  Column(){
                    Image($r('app.media.888'))
                      .width('100%')
                      .aspectRatio(1.756)


                    Row(){
                      Text('2025全国大学生数学建模竞赛')
                        .fontWeight(700)
                        .fontSize(13)
                    }
                    .padding(12)
                    .justifyContent(FlexAlign.Start)
                    .width('100%')
                    Row(){
                      Text('报名截至：2025-10-29')
                        .fontSize(9)
                        .fontColor('#6B7280')


                    }
                    .padding({left:12,right:12})
                    .justifyContent(FlexAlign.Start)
                    .width('100%')

                    Row(){
                      Text('已有555人报名')
                        .fontSize(9)
                        .fontColor('#9CA3AF')
                    }
                    .padding({left:12,right:12,top:12})
                    .justifyContent(FlexAlign.Start)
                    .width('100%')
                  }
                  .borderRadius(15)
                  .backgroundColor(Color.White)
                  .height(229)
                  .width(250)
                  Column(){
                    Image($r('app.media.888'))
                      .width('100%')
                      .aspectRatio(1.756)


                    Row(){
                      Text('2025全国大学生数学建模竞赛')
                        .fontWeight(700)
                        .fontSize(13)
                    }
                    .padding(12)
                    .justifyContent(FlexAlign.Start)
                    .width('100%')
                    Row(){
                      Text('报名截至：2025-10-29')
                        .fontSize(9)
                        .fontColor('#6B7280')


                    }
                    .padding({left:12,right:12})
                    .justifyContent(FlexAlign.Start)
                    .width('100%')

                    Row(){
                      Text('已有333人报名')
                        .fontSize(9)
                        .fontColor('#9CA3AF')
                    }
                    .padding({left:12,right:12,top:12})
                    .justifyContent(FlexAlign.Start)
                    .width('100%')
                  }
                  .borderRadius(15)
                  .backgroundColor(Color.White)
                  .height(229)
                  .width(250)
                }
                .padding(10)
              }

              .height('100%')
              .width('100%')
              .scrollBar(BarState.Off)
              .scrollable(ScrollDirection.Horizontal)
            }
            .height(230)
            .width('100%')
            .borderRadius(10)
            .border({width:3,color:'#f5f5f5'})


            //最新咨询
            Row(){
              Text('最新咨询')
                .fontWeight(700)
              Row(){
                Text('查看更多')
                  .fontSize(12)
                  .fontColor('#4e8ef4')
                Image($r('app.media.jinru'))
                  .fillColor('#4e8ef4')
                  .width(15)
              }
            }
            .margin({top:15,bottom:10})
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
            .backgroundColor('#f1f1f1')
            .padding({left:15,right:15})
            .width('100%')

            Row(){
              Row(){
                Image($r('app.media.8'))
                  .width(75)
                  .borderRadius(10)
              }
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .height('100%')
              .width(90)

              Column(){
                Row(){
                  Text('2025年研究生推免政策重大调整')
                    .fontWeight(700)
                    .fontSize(12)
                }
                .justifyContent(FlexAlign.Start)
                .width('100%')

                Row(){
                  Text('教育部最新发布通知，对2025年推免加分项目进行调整，新增多个认')
                    .fontSize(11)
                    .fontColor('#6B7280')
                }
                .margin({top:10,bottom:10})
                .justifyContent(FlexAlign.Start)
                .width('100%')

               Row(){
                 Row(){
                   Text('2025-02-28')
                     .fontSize(10)
                     .fontColor('#6B7280')
                   Row({space:3}){
                     Image($r('app.media.yanjing'))
                       .width(10)
                     Text('2,391')
                       .fontSize(10)
                       .fontColor('#6B7280')
                   }
                   Row({space:3}){
                     Image($r('app.media.dianz'))
                       .width(10)
                     Text('328')
                       .fontSize(10)
                       .fontColor('#6B7280')
                   }
                 }
                 .justifyContent(FlexAlign.SpaceBetween)
                 .width('70%')
               }
               .justifyContent(FlexAlign.Start)
               .width('100%')
              }
              .padding({top:15,bottom:10})
              // .backgroundColor(Color.Pink)
              .height('100%')
              .width(200)
            }
            .padding({left:3,right:10})
            .borderRadius(10)
            .backgroundColor(Color.White)
            .width(300)
            .height(100)

            Row(){

            }
            .height(100)
          }




        }
        .height(470)

      }
      .height(470)
      .width('100%')




    }
    .backgroundColor('#f1f1f1')
    .height('100%')
    .width('100%')
    .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
  }

}