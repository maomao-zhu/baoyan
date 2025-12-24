import { HDMNavBar } from '../components/HDMNavBar'

@Entry
@Component
struct XinXiShnagChuanPage {
  @State projectName: string = ''
  @State startTime: string = ''
  @State endTime: string = ''
  @State location: string = ''
  @State practiceType: string = '请选择实践类型'
  @State description: string = ''
  @State showStartDatePicker: boolean = false
  @State showEndDatePicker: boolean = false
  @State showPracticeTypePicker: boolean = false
  @State selectedDate: Date = new Date()
  @State uploadedFiles: string[] = []
  @State uploadedPhotos: string[] = []

  // 实践类型选项
  practiceTypes: string[] = ['志愿服务', '社会实践', '社会调研', '社区服务', '企业实习', '其他']

  build() {
    Column() {
      HDMNavBar({ title: '信息上传' })

      Scroll() {
        Column({ space: 20 }) {
          // 实践项目名称
          Column() {
            Text('实践项目名称*')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请输入项目名称', text: this.projectName })
              .onChange((value: string) => {
                this.projectName = value
              })
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .width('100%')
              .height(40)
          }
          .width('90%')

          // 开始时间和结束时间
          Column() {
            Text('开始时间*                     结束时间*')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            Row({ space: 10 }) {
              // 开始时间选择框
              Column() {
                Text(this.startTime || '请选择开始时间')
                  .fontSize(14)
                  .fontColor(this.startTime ? '#333333' : '#999999')
                  .width('100%')
                  .textAlign(TextAlign.Start)
              }
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .width('100%')
              .height(40)
              .onClick(() => {
                this.showStartDatePicker = true
                console.log('点击开始时间选择框')
              })
              .layoutWeight(1)

              // 结束时间选择框
              Column() {
                Text(this.endTime || '请选择结束时间')
                  .fontSize(14)
                  .fontColor(this.endTime ? '#333333' : '#999999')
                  .width('100%')
                  .textAlign(TextAlign.Start)
              }
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .width('100%')
              .height(40)
              .onClick(() => {
                this.showEndDatePicker = true
                console.log('点击结束时间选择框')
              })
              .layoutWeight(1)
            }
            .width('100%')
          }
          .width('90%')

          // 实践地点
          Column() {
            Text('实践地点*')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请输入实践地点', text: this.location })
              .onChange((value: string) => {
                this.location = value
              })
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .width('100%')
              .height(40)
          }
          .width('90%')

          // 实践类型
          Column() {
            Text('实践类型*')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            // 实践类型选择框
            Column() {
              Row() {
                Text(this.practiceType)
                  .fontSize(14)
                  .fontColor(this.practiceType === '请选择实践类型' ? '#999999' : '#333333')
                  .layoutWeight(1)

                Image($r('app.media.xiala'))
                  .width(12)
                  .height(12)
              }
              .padding(12)
              .justifyContent(FlexAlign.SpaceBetween)
              .width('100%')
            }
            .backgroundColor(Color.White)
            .borderRadius(8)
            .width('100%')
            .height(40)
            .onClick(() => {
              this.showPracticeTypePicker = true
            })
          }
          .width('90%')

          // 实践内容描述
          Column() {
            Text('实践内容描述*')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请详细描述实践过程、个人职责和实践成果', text: this.description })
              .onChange((value: string) => {
                this.description = value
              })
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .width('100%')
              .height(120)
          }
          .width('90%')

          // 支撑材料上传
          Column() {
            Text('支撑材料上传')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 8 })

            // 上传证明
            Column() {
              Row() {
                Text('上传证明')
                  .fontSize(14)
                  .fontColor('#333333')
                  .layoutWeight(1)

                Text(this.uploadedFiles.length > 0 ? '已上传' : '未上传')
                  .fontSize(12)
                  .fontColor(this.uploadedFiles.length > 0 ? '#4CAF50' : '#999999')
              }
              .padding(12)
              .justifyContent(FlexAlign.SpaceBetween)
              .width('100%')
            }
            .backgroundColor(Color.White)
            .borderRadius(8)
            .width('100%')
            .height(40)
            .onClick(() => {
              this.uploadFile()
            })

            // 活动照片
            Column() {
              Row() {
                Text('活动照片')
                  .fontSize(14)
                  .fontColor('#333333')
                  .layoutWeight(1)

                Text(this.uploadedPhotos.length > 0 ? `已上传${this.uploadedPhotos.length}张` : '未上传')
                  .fontSize(12)
                  .fontColor(this.uploadedPhotos.length > 0 ? '#4CAF50' : '#999999')
              }
              .padding(12)
              .justifyContent(FlexAlign.SpaceBetween)
              .width('100%')
            }
            .backgroundColor(Color.White)
            .borderRadius(8)
            .width('100%')
            .height(40)
            .margin({ top: 10 })
            .onClick(() => {
              this.uploadPhoto()
            })

            // 上传限制说明
            Text('最多上传5张图片，每张不超过5MB')
              .fontSize(12)
              .fontColor('#999999')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ top: 8 })

            // 已上传图片预览
            if (this.uploadedPhotos.length > 0) {
              Scroll() {
                Row({ space: 10 }) {
                  ForEach(this.uploadedPhotos, (photo: string, index: number) => {
                    Stack() {
                      Image(photo)
                        .width(80)
                        .height(80)
                        .borderRadius(8)

                      // 删除按钮
                      Column() {
                        Image($r('app.media.guanbi'))
                          .width(16)
                          .height(16)
                      }
                      .width(20)
                      .height(20)
                      .backgroundColor('#FF3B30')
                      .borderRadius(10)
                      .position({ x: 70, y: -5 })
                      .onClick(() => {
                        this.deletePhoto(index)
                      })
                    }
                    .width(80)
                    .height(80)
                  })
                }
                .padding(8)
                .width('100%')
              }
              .scrollable(ScrollDirection.Horizontal)
              .height(90)
              .width('100%')
              .margin({ top: 10 })
            }
          }
          .width('90%')

          // 提交按钮
          Column() {
            Text('提交信息')
              .fontSize(16)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Medium)
          }
          .width('90%')
          .height(45)
          .backgroundColor('#757575')
          .borderRadius(8)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.submitForm()
          })
        }
        .width('100%')
        .padding(20)
        .alignItems(HorizontalAlign.Center)
      }
      .layoutWeight(1)
      .width('100%')

      // 开始时间选择器弹窗
      if (this.showStartDatePicker) {
        this.buildDatePicker('start')
      }

      // 结束时间选择器弹窗
      if (this.showEndDatePicker) {
        this.buildDatePicker('end')
      }

      // 实践类型选择器弹窗
      if (this.showPracticeTypePicker) {
        this.buildPracticeTypePicker()
      }
    }
    .backgroundColor('#f1f1f1')
    .height('100%')
    .width('100%')
  }

  // 构建日期选择器
  @Builder
  buildDatePicker(type: string) {
    // 创建遮罩层
    Column() {
      // 空白的可点击区域，点击后关闭弹窗
      Column()
        .width('100%')
        .height('30%')
        .onClick(() => {
          if (type === 'start') {
            this.showStartDatePicker = false
          } else {
            this.showEndDatePicker = false
          }
        })

      // 日期选择器内容
      Column() {
        Column() {
          // 标题栏
          Row() {
            Text('取消')
              .fontSize(16)
              .fontColor('#007AFF')
              .onClick(() => {
                if (type === 'start') {
                  this.showStartDatePicker = false
                } else {
                  this.showEndDatePicker = false
                }
              })

            Text(type === 'start' ? '选择开始时间' : '选择结束时间')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .layoutWeight(1)
              .textAlign(TextAlign.Center)

            Text('确定')
              .fontSize(16)
              .fontColor('#007AFF')
              .onClick(() => {
                const formattedDate = `${this.selectedDate.getFullYear()}.${(this.selectedDate.getMonth() + 1).toString().padStart(2, '0')}.${this.selectedDate.getDate().toString().padStart(2, '0')}`
                if (type === 'start') {
                  this.startTime = formattedDate
                  this.showStartDatePicker = false
                } else {
                  this.endTime = formattedDate
                  this.showEndDatePicker = false
                }
              })
          }
          .padding(16)
          .width('100%')
          .backgroundColor(Color.White)

          // 日期选择器
          DatePicker({
            start: new Date('2020-01-01'),
            end: new Date('2030-12-31'),
            selected: this.selectedDate
          })
            .onChange((value: DatePickerResult) => {
              // 使用非空断言
              this.selectedDate = new Date(value.year!, value.month! - 1, value.day!)
            })
            .width('100%')
            .height(200)
        }
        .backgroundColor(Color.White)
        .borderRadius(16)
        .width('90%')
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0,0,0,0.5)')
    .position({ x: 0, y: 0 })
  }

  // 构建实践类型选择器
  @Builder
  buildPracticeTypePicker() {
    // 创建遮罩层
    Column() {
      // 空白的可点击区域，点击后关闭弹窗
      Column()
        .width('100%')
        .height('30%')
        .onClick(() => {
          this.showPracticeTypePicker = false
        })

      Column() {
        Column() {
          // 标题
          Text('选择实践类型')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(16)

          // 类型列表
          Column() {
            ForEach(this.practiceTypes, (type: string) => {
              Column() {
                Text(type)
                  .fontSize(16)
                  .fontColor('#333333')
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .padding(12)
              }
              .width('100%')
              .backgroundColor(this.practiceType === type ? '#f0f0f0' : Color.White)
              .onClick(() => {
                this.practiceType = type
                this.showPracticeTypePicker = false
              })
            })
          }
          .width('100%')

          // 取消按钮
          Column() {
            Text('取消')
              .fontSize(16)
              .fontColor('#007AFF')
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding(12)
          }
          .width('100%')
          .margin({ top: 8 })
          .backgroundColor(Color.White)
          .onClick(() => {
            this.showPracticeTypePicker = false
          })
        }
        .backgroundColor('#f5f5f5')
        .borderRadius(16)
        .width('80%')
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0,0,0,0.5)')
    .position({ x: 0, y: 0 })
  }

  // 上传文件
  uploadFile() {
    // 这里实现文件上传逻辑
    console.log('上传证明文件')
    // 模拟上传成功
    this.uploadedFiles = ['证明文件.pdf']
  }

  // 上传照片
  uploadPhoto() {
    if (this.uploadedPhotos.length >= 5) {
      console.log('最多只能上传5张图片')
      return
    }

    // 这里实现图片上传逻辑
    console.log('上传活动照片')
    // 模拟上传成功
    this.uploadedPhotos.push(`photo_${this.uploadedPhotos.length + 1}.jpg`)
  }

  // 删除照片
  deletePhoto(index: number) {
    this.uploadedPhotos.splice(index, 1)
  }

  // 提交表单
  submitForm() {
    // 验证表单数据
    if (!this.projectName.trim()) {
      console.log('请填写项目名称')
      return
    }
    if (!this.startTime || !this.endTime) {
      console.log('请选择时间')
      return
    }
    if (!this.location.trim()) {
      console.log('请填写实践地点')
      return
    }
    if (this.practiceType === '请选择实践类型') {
      console.log('请选择实践类型')
      return
    }
    if (!this.description.trim()) {
      console.log('请填写实践内容描述')
      return
    }

    // 提交逻辑
    console.log('提交信息:', {
      projectName: this.projectName,
      startTime: this.startTime,
      endTime: this.endTime,
      location: this.location,
      practiceType: this.practiceType,
      description: this.description,
      files: this.uploadedFiles,
      photos: this.uploadedPhotos
    })

    // 这里可以添加实际的上传逻辑
  }
}