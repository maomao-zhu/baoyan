import { HDMNavBar } from '../components/HDMNavBar'

@Entry
@Component
struct XueKeJingSaiPage {
  @State currentTab: number = 0
  tabTitles: string[] = ['全部', '理工类', '文学类', '经管类', '艺术类']

  @Builder
  buildAllContent() {
    Column({space:10}){
      //1
     Column(){
      Row(){
        Text('全国大学生数学建模竞赛')
          .fontSize(13)
          .fontWeight(700)
        Image($r('app.media.jinru'))
          .width(20)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left:15,right:15,top:15,bottom:8})
      .width('100%')


       Row({space:10}){
        Row(){
          Text('国家级')
            .fontSize(12)
            .fontColor('#585858')
        }
        .justifyContent(FlexAlign.Center)
        .borderRadius(3)
        .backgroundColor('#ebebeb')
        .height(25)
        .width(50)

         Text('加分:    5.0')
           .fontSize(13)
           .fontColor('#585858')
       }
       .padding({left:15,right:15})
       .width('100%')
     }
     .backgroundColor(Color.White)
     .height(80)
     .width(330)
      .borderRadius(10)

      //2
      Column(){
        Row(){
          Text('中国“互联网+”大学生创新创业大赛')
            .fontSize(13)
            .fontWeight(700)
          Image($r('app.media.jinru'))
            .width(20)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({left:15,right:15,top:15,bottom:8})
        .width('100%')


        Row({space:10}){
          Row(){
            Text('国家级')
              .fontSize(12)
              .fontColor('#585858')
          }
          .justifyContent(FlexAlign.Center)
          .borderRadius(3)
          .backgroundColor('#ebebeb')
          .height(25)
          .width(50)

          Text('加分:    4.5')
            .fontSize(13)
            .fontColor('#585858')
        }
        .padding({left:15,right:15})
        .width('100%')
      }
      .backgroundColor(Color.White)
      .height(80)
      .width(330)
      .borderRadius(10)


      //3
      Column(){
        Row(){
          Text('全国大学生英语竞赛')
            .fontSize(13)
            .fontWeight(700)
          Image($r('app.media.jinru'))
            .width(20)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({left:15,right:15,top:15,bottom:8})
        .width('100%')


        Row({space:10}){
          Row(){
            Text('省级')
              .fontSize(12)
              .fontColor('#585858')
          }
          .justifyContent(FlexAlign.Center)
          .borderRadius(3)
          .backgroundColor('#ebebeb')
          .height(25)
          .width(50)

          Text('加分:    3.0')
            .fontSize(13)
            .fontColor('#585858')
        }
        .padding({left:15,right:15})
        .width('100%')
      }
      .backgroundColor(Color.White)
      .height(80)
      .width(330)
      .borderRadius(10)


      //4
      Column(){
        Row(){
          Text('全国大学生机械创新设计大赛')
            .fontSize(13)
            .fontWeight(700)
          Image($r('app.media.jinru'))
            .width(20)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({left:15,right:15,top:15,bottom:8})
        .width('100%')


        Row({space:10}){
          Row(){
            Text('国家级')
              .fontSize(12)
              .fontColor('#585858')
          }
          .justifyContent(FlexAlign.Center)
          .borderRadius(3)
          .backgroundColor('#ebebeb')
          .height(25)
          .width(50)

          Text('加分:    4.0')
            .fontSize(13)
            .fontColor('#585858')
        }
        .padding({left:15,right:15})
        .width('100%')
      }
      .backgroundColor(Color.White)
      .height(80)
      .width(330)
      .borderRadius(10)


      //5
      Column(){
        Row(){
          Text('全国大学生电子设计竞赛')
            .fontSize(13)
            .fontWeight(700)
          Image($r('app.media.jinru'))
            .width(20)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({left:15,right:15,top:15,bottom:8})
        .width('100%')


        Row({space:10}){
          Row(){
            Text('省级')
              .fontSize(12)
              .fontColor('#585858')
          }
          .justifyContent(FlexAlign.Center)
          .borderRadius(3)
          .backgroundColor('#ebebeb')
          .height(25)
          .width(50)

          Text('加分:    3.5')
            .fontSize(13)
            .fontColor('#585858')
        }
        .padding({left:15,right:15})
        .width('100%')
      }
      .backgroundColor(Color.White)
      .height(80)
      .width(330)
      .borderRadius(10)


      Row(){
       Row(){
         Text('共计5个竞赛项目')
           .fontSize(13)
       }
       Row(){
         Text('更新时间：2025-09-12')
       }

      }
      .padding({left:15,right:15})
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(Color.White)
      .height(50)
      .width('100%')
      .offset({
        y:100
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  // 理工类内容
  @Builder
  buildScienceContent() {
    Column() {
      Text('理工类竞赛内容')
        .fontSize(16)
        .fontColor(Color.Black)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // 文学类内容
  @Builder
  buildLiteratureContent() {
    Column() {
      Text('文学类竞赛内容')
        .fontSize(16)
        .fontColor(Color.Black)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // 经管类内容
  @Builder
  buildManagementContent() {
    Column() {
      Text('经管类竞赛内容')
        .fontSize(16)
        .fontColor(Color.Black)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // 艺术类内容
  @Builder
  buildArtContent() {
    Column() {
      Text('艺术类竞赛内容')
        .fontSize(16)
        .fontColor(Color.Black)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }



  build() {
    Column() {
      HDMNavBar({ title: '学科竞赛'})

      // 搜索框
      Row() {
        Search({
          value: '搜索竞赛名称或级别',
          placeholder: '搜索竞赛名称或级别'
        })
          .fontColor('#ccc')
          .textFont({ size: 12, style: FontStyle.Normal })
          .height(35)
          .backgroundColor(Color.White)
          .placeholderFont({ size: 7, family: null, style: FontStyle.Italic })
          .searchIcon({ size: 15, color: Color.Black, src: '/image/sous.svg' })
          .layoutWeight(1)
      }
      .height(60)
      .padding({ left: 10, right: 10 })
      .width('100%')

      // 可左右滑动的Tabs栏
      Scroll() {
        Row() {
          ForEach(this.tabTitles, (title: string, index: number) => {
            Column() {
              Text(title)
                .fontSize(14)
                .fontColor(this.currentTab === index ? Color.White : Color.Black)
                .padding({ left: 16, right: 16, top: 10, bottom: 10 })
            }
            .backgroundColor(this.currentTab === index ? '#909090' : Color.White)
            .borderRadius(20)
            .margin({ right: 8 })
            .onClick(() => {
              this.currentTab = index
            })
          })
        }
        .padding(10)
        .width('100%')
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off) // 隐藏滚动条
      .width('100%')
      .height(60)

      // 内容区域
      Column() {
        if (this.currentTab === 0) {
          this.buildAllContent()
        } else if (this.currentTab === 1) {
          this.buildScienceContent()
        } else if (this.currentTab === 2) {
          this.buildLiteratureContent()
        } else if (this.currentTab === 3) {
          this.buildManagementContent()
        } else if (this.currentTab === 4) {
          this.buildArtContent()
        }
      }
      .layoutWeight(1)
      .width('100%')

    }
    .backgroundColor('#f1f1f1')
    .height('100%')
    .width('100%')
  }
}