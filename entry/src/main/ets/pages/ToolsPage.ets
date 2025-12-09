import { CommonConstants } from '../common/constants/CommonConstants';
import { promptAction, curves } from '@kit.ArkUI';
import { vibrator } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';

interface Quote {
  text: string;
  author: string;
}

@Component
export struct ToolsPage {
  // --- Breathing State ---
  @State breathingState: 'Idle' | 'Inhale' | 'Hold' | 'Exhale' = 'Idle';
  @State breathScale: number = 1.0;
  @State breathText: string = '点击开始';
  @State breathColor: ResourceColor = '#DBEAFE'; // Default: Blue-100
  private timerIds: number[] = [];

  // --- White Noise State ---
  @State isWhiteNoisePlaying: boolean = false;
  private avPlayer: media.AVPlayer | undefined = undefined;

  // --- 2048 Game State ---
  @State isGame2048Open: boolean = false;
  @State board: number[] = Array(16).fill(0);
  @State score: number = 0;
  @State bestScore: number = 0;
  @State isGameOver: boolean = false;

  // --- Quote State ---
  @State currentQuote: Quote = {
    text: '万物皆有裂痕，那是光照进来的地方。',
    author: '莱昂纳德·科恩'
  };
  @State quoteOpacity: number = 1.0;
  @State quoteScale: number = 1.0;

  private quotes: Quote[] = [
    { text: '万物皆有裂痕，那是光照进来的地方。', author: '莱昂纳德·科恩' },
    { text: '生活不是等待风暴过去，而是学会在雨中跳舞。', author: '维维安·格林' },
    { text: '凡是过往，皆为序章。', author: '莎士比亚' },
    { text: '世界上只有一种英雄主义，就是在认清生活真相之后依然热爱生活。', author: '罗曼·罗兰' },
    { text: '慢下来，你并没有落后。', author: '佚名' }
  ];

  aboutToDisappear(): void {
    this.clearAllTimers();
    this.releaseAVPlayer();
    try {
      vibrator.stopVibration();
    } catch (e) {
      // Ignore
    }
  }

  build() {
    Column() {
      // Header
      Row() {
        Text('情绪急救')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonConstants.COLOR_PRIMARY)
      }
      .width('100%')
      .padding({ left: 24, right: 24, top: 12, bottom: 16 })

      Scroll() {
        Column({ space: 20 }) {
          // Featured Card: 4-7-8 Breathing
          this.FeaturedCard()

          // Tools Grid
          Grid() {
            GridItem() {
              ToolCardItem({
                title: '2048',
                subtitle: '数字益智',
                bgColor: '#FCE7F3',
                emoji: '🧩',
                action: () => {
                  this.initGame2048();
                  this.isGame2048Open = true;
                }
              })
            }
            
            GridItem() {
              ToolCardItem({
                title: '治愈金句',
                subtitle: '每日心灵慰藉',
                bgColor: '#F3E8FF',
                emoji: '❞',
                action: () => this.refreshQuote()
              })
            }

            GridItem() {
              ToolCardItem({
                title: '白噪音',
                subtitle: this.isWhiteNoisePlaying ? '正在播放: 雨声' : '雨声, 森林...',
                bgColor: '#DCFCE7',
                emoji: this.isWhiteNoisePlaying ? '⏸️' : '🎵',
                action: () => {
                  this.toggleWhiteNoise();
                }
              })
            }

            GridItem() {
              ToolCardItem({
                title: '紧急求助',
                subtitle: '专业热线',
                bgColor: '#FEE2E2',
                emoji: '📞',
                action: () => {
                  AlertDialog.show({
                    title: '紧急求助',
                    message: '是否拨打心理咨询热线？\n12345',
                    primaryButton: {
                      value: '取消',
                      action: () => {}
                    },
                    secondaryButton: {
                      value: '拨打',
                      fontColor: '#EF4444',
                      action: () => {
                        promptAction.showToast({ message: '正在拨号...' });
                      }
                    }
                  })
                }
              })
            }
          }
          .columnsTemplate('1fr 1fr')
          .columnsGap(12)
          .rowsGap(12)
          .height(280)

          // Quote Card
          this.QuoteCard()
          
          // Bottom Padding
          Blank().height(80)
        }
        .padding({ left: 24, right: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(CommonConstants.COLOR_BG)
    .bindSheet($$this.isGame2048Open, this.Game2048Builder(), {
      height: SheetSize.LARGE, // Use large for better game view
      dragBar: true,
      backgroundColor: '#FAF8EF', // 2048 classic bg color
      onDisappear: () => {
        // Optional: save state?
      }
    })
  }

  // --- Breathing Exercise Logic ---
  
  private addTimer(id: number) {
    this.timerIds.push(id);
  }

  private clearAllTimers() {
    this.timerIds.forEach(id => clearTimeout(id));
    this.timerIds = [];
  }

  startBreathing(): void {
    if (this.breathingState !== 'Idle') {
      this.resetBreathing();
      return;
    }
    this.performInhale();
  }

  resetBreathing(): void {
    this.clearAllTimers();
    animateTo({ duration: 500, curve: curves.springMotion() }, () => {
      this.breathScale = 1.0;
      this.breathColor = '#DBEAFE';
    });
    this.breathingState = 'Idle';
    this.breathText = '点击开始';
    try {
      vibrator.stopVibration();
    } catch (e) {}
  }

  private performInhale() {
    this.breathingState = 'Inhale';
    this.breathText = '吸气 (4s)';
    
    // Haptic: Long vibration for inhale
    try {
      vibrator.startVibration({ type: 'time', duration: 2000 }, { id: 0, usage: 'unknown' });
    } catch (e) {}

    animateTo({ duration: 4000, curve: Curve.EaseInOut }, () => {
      this.breathScale = 1.5;
      this.breathColor = '#3B82F6'; // Blue-500
    });

    const id = setTimeout(() => {
      if (this.breathingState === 'Idle') return;
      this.performHold();
    }, 4000);
    this.addTimer(id);
  }

  private performHold() {
    this.breathingState = 'Hold';
    this.breathText = '憋气 (7s)';
    
    animateTo({ duration: 7000, curve: Curve.Linear }, () => {
       this.breathColor = '#06B6D4'; // Cyan-500
    });

    const id = setTimeout(() => {
      if (this.breathingState === 'Idle') return;
      this.performExhale();
    }, 7000);
    this.addTimer(id);
  }

  private performExhale() {
    this.breathingState = 'Exhale';
    this.breathText = '呼气 (8s)';
    
    // Haptic: Pulse vibration
    this.triggerExhaleVibration();

    animateTo({ duration: 8000, curve: Curve.EaseInOut }, () => {
      this.breathScale = 1.0;
      this.breathColor = '#8B5CF6'; // Violet-500
    });

    const id = setTimeout(() => {
      if (this.breathingState === 'Idle') return;
      // Loop
      this.performInhale();
    }, 8000);
    this.addTimer(id);
  }

  private triggerExhaleVibration() {
      const durations = [100, 100, 100];
      let delay = 0;
      durations.forEach((d, index) => {
          const tid = setTimeout(() => {
              if (this.breathingState !== 'Exhale') return;
              try {
                vibrator.startVibration({ type: 'time', duration: d }, { id: 0, usage: 'unknown' });
              } catch (e) {}
          }, delay);
          this.addTimer(tid);
          delay += d + 200; // Interval
      });
  }

  @Builder
  FeaturedCard() {
    Stack({ alignContent: Alignment.TopStart }) {
      // Background Gradient
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 135,
          colors: [['#EFF6FF', 0.0], ['#FFFFFF', 1.0]]
        })
        .borderRadius(24)
        .shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 4 })

      // Animated Circle Background
      Column()
        .width(150)
        .height(150)
        .borderRadius(75)
        .backgroundColor(this.breathColor) // Dynamic Color
        .opacity(0.2)
        .scale({ x: this.breathScale, y: this.breathScale })
        .position({ x: '50%', y: '50%' })
        .translate({ x: -75, y: -75 }) // Center
        .animation({ duration: 1000, curve: Curve.EaseInOut }) // Fallback animation

      // Content
      Column() {
        Row() {
          Text('🫁')
            .fontSize(28)
            .margin({ right: 12 })
          Column({ space: 4 }) {
            Text('4-7-8 呼吸法')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(CommonConstants.COLOR_PRIMARY)
            Text('缓解焦虑，助眠放松')
              .fontSize(14)
              .fontColor(CommonConstants.COLOR_SECONDARY)
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .margin({ bottom: 32 })

        // Status Text
        Text(this.breathText)
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonConstants.COLOR_PRIMARY)
          .animation({ duration: 300 })
        
        Text(this.breathingState === 'Idle' ? '点击开始练习' : '跟随圆圈节奏')
          .fontSize(14)
          .fontColor(CommonConstants.COLOR_SECONDARY)
          .margin({ top: 8 })

        // Control Button
        Button(this.breathingState === 'Idle' ? '开始' : '停止')
          .backgroundColor(this.breathingState === 'Idle' ? '#3B82F6' : '#EF4444')
          .fontColor(Color.White)
          .height(36)
          .margin({ top: 24 })
          .onClick(() => {
            this.startBreathing();
          })
      }
      .width('100%')
      .height('100%')
      .padding(24)
      .alignItems(HorizontalAlign.Center)
      
      // Decorative Icon
      Text('☁️')
        .fontSize(80)
        .opacity(0.2)
        .position({ x: '75%', y: '65%' })
    }
    .width('100%')
    .height(240)
  }

  // --- 2048 Game Logic ---

  initGame2048() {
    this.board = Array(16).fill(0);
    this.score = 0;
    this.isGameOver = false;
    this.addRandomTile();
    this.addRandomTile();
  }

  addRandomTile() {
    let emptyIndices: number[] = [];
    for (let i = 0; i < 16; i++) {
      if (this.board[i] === 0) emptyIndices.push(i);
    }
    if (emptyIndices.length > 0) {
      let randomIndex = emptyIndices[Math.floor(Math.random() * emptyIndices.length)];
      // 90% chance for 2, 10% chance for 4
      this.board[randomIndex] = Math.random() < 0.9 ? 2 : 4;
    }
  }

  getTileColor(value: number): string {
    switch (value) {
      case 2: return '#EEE4DA';
      case 4: return '#EDE0C8';
      case 8: return '#F2B179';
      case 16: return '#F59563';
      case 32: return '#F67C5F';
      case 64: return '#F65E3B';
      case 128: return '#EDCF72';
      case 256: return '#EDCC61';
      case 512: return '#EDC850';
      case 1024: return '#EDC53F';
      case 2048: return '#EDC22E';
      default: return '#CDC1B4'; // 0 or others
    }
  }

  getTileTextColor(value: number): string {
    return value <= 4 ? '#776E65' : '#F9F6F2';
  }

  // Swipe Handlers
  handleSwipe(direction: 'left' | 'right' | 'up' | 'down') {
    if (this.isGameOver) return;

    let moved = false;
    let newBoard = [...this.board];
    let newScore = this.score;

    // Logic: 
    // 1. Extract lines (rows for L/R, cols for U/D)
    // 2. Process each line: Slide -> Merge -> Slide
    // 3. Put back

    for (let i = 0; i < 4; i++) {
      let line: number[] = [];
      let indices: number[] = [];

      // Extract line
      for (let j = 0; j < 4; j++) {
        let index = 0;
        if (direction === 'left') index = i * 4 + j;
        else if (direction === 'right') index = i * 4 + (3 - j);
        else if (direction === 'up') index = j * 4 + i;
        else if (direction === 'down') index = (3 - j) * 4 + i;
        
        indices.push(index);
        line.push(newBoard[index]);
      }

      // Process line
      let filtered = line.filter(v => v !== 0);
      let merged: number[] = [];
      
      for (let k = 0; k < filtered.length; k++) {
        if (k + 1 < filtered.length && filtered[k] === filtered[k + 1]) {
          let val = filtered[k] * 2;
          merged.push(val);
          newScore += val;
          k++; // Skip next
        } else {
          merged.push(filtered[k]);
        }
      }

      // Pad with zeros
      while (merged.length < 4) merged.push(0);

      // Check change and update
      for (let j = 0; j < 4; j++) {
        if (newBoard[indices[j]] !== merged[j]) {
          moved = true;
          newBoard[indices[j]] = merged[j];
        }
      }
    }

    if (moved) {
      this.board = newBoard;
      this.score = newScore;
      if (this.score > this.bestScore) this.bestScore = this.score;
      this.addRandomTile();
      
      // Simple Game Over Check (Board full)
      if (!this.board.includes(0)) {
        // TODO: Strict check (can move?)
        // For now just assume if full, risk of game over. 
        // Not setting isGameOver strictly to allow user to try if merges exist.
      }
    }
  }

  @Builder
  Game2048Builder() {
    Column() {
      // Header
      Row() {
        Text('2048')
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor('#776E65')
        
        Blank()

        Column() {
          Text('SCORE')
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor('#EEE4DA')
          Text(this.score.toString())
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .backgroundColor('#BBADA0')
        .padding({ left: 16, right: 16, top: 4, bottom: 4 })
        .borderRadius(4)
        .margin({ right: 8 })

        Column() {
          Text('BEST')
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor('#EEE4DA')
          Text(this.bestScore.toString())
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .backgroundColor('#BBADA0')
        .padding({ left: 16, right: 16, top: 4, bottom: 4 })
        .borderRadius(4)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 24, bottom: 24 })
      .alignItems(VerticalAlign.Center)

      // Game Board
      Column() {
        Grid() {
          ForEach(this.board, (num: number, index: number) => {
            GridItem() {
              Stack() {
                // Tile Background
                Rect()
                  .width('100%')
                  .height('100%')
                  .fill(this.getTileColor(num))
                  .radius(4)
                
                // Tile Number
                if (num > 0) {
                  Text(num.toString())
                    .fontSize(num > 512 ? 24 : 32)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(this.getTileTextColor(num))
                }
              }
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr 1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .width('100%')
        .height('100%')
      }
      .width(340) // Fixed width for 4x4
      .height(340)
      .backgroundColor('#BBADA0')
      .borderRadius(6)
      .padding(10)
      .gesture(
        PanGesture({ direction: PanDirection.All })
          .onActionEnd((event: GestureEvent) => {
            if (Math.abs(event.offsetX) > Math.abs(event.offsetY)) {
              // Horizontal
              if (event.offsetX > 20) this.handleSwipe('right');
              else if (event.offsetX < -20) this.handleSwipe('left');
            } else {
              // Vertical
              if (event.offsetY > 20) this.handleSwipe('down');
              else if (event.offsetY < -20) this.handleSwipe('up');
            }
          })
      )

      // Instructions
      Text('滑动手指移动方块，相同数字合并')
        .fontSize(14)
        .fontColor('#776E65')
        .margin({ top: 32 })
      
      Button('重新开始')
        .backgroundColor('#8F7A66')
        .fontColor(Color.White)
        .margin({ top: 16 })
        .onClick(() => {
          this.initGame2048();
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAF8EF')
  }

  // --- Quote Logic ---
  refreshQuote(): void {
    // Animate out
    animateTo({ duration: 300, curve: Curve.EaseOut }, () => {
      this.quoteOpacity = 0.0;
      this.quoteScale = 0.95;
    });

    setTimeout(() => {
      const randomIndex = Math.floor(Math.random() * this.quotes.length);
      this.currentQuote = this.quotes[randomIndex];
      
      // Animate in
      animateTo({ duration: 300, curve: Curve.EaseIn }, () => {
        this.quoteOpacity = 1.0;
        this.quoteScale = 1.0;
      });
    }, 300);
  }

  // --- White Noise Logic ---
  private async initAVPlayer(): Promise<void> {
    try {
      if (this.avPlayer) return;
      
      this.avPlayer = await media.createAVPlayer();
      console.info('AVPlayer created');
      
      this.avPlayer.on('stateChange', async (state: media.AVPlayerState, reason: media.StateChangeReason) => {
        console.info(`AVPlayer state change: ${state}, reason: ${reason}`);
        switch (state) {
          case 'idle':
            // Reset called, reload source
            try {
              const context = getContext(this) as common.UIAbilityContext;
              const fileDescriptor = await context.resourceManager.getRawFd('rain.mp3');
              console.info(`AVPlayer idle, loading fd: ${fileDescriptor.fd}, offset: ${fileDescriptor.offset}, length: ${fileDescriptor.length}`);
              this.avPlayer!.fdSrc = fileDescriptor;
            } catch (err) {
              console.error(`Failed to load rawfile in idle state: ${JSON.stringify(err)}`);
            }
            break;
          case 'initialized':
            console.info('AVPlayer initialized, preparing...');
            this.avPlayer!.prepare();
            break;
          case 'prepared':
            console.info('AVPlayer prepared, starting playback...');
            this.avPlayer!.loop = true;
            this.avPlayer!.play();
            break;
          case 'playing':
            console.info('AVPlayer playing');
            this.isWhiteNoisePlaying = true;
            break;
          case 'paused':
            console.info('AVPlayer paused');
            this.isWhiteNoisePlaying = false;
            break;
          case 'stopped':
            console.info('AVPlayer stopped');
            this.isWhiteNoisePlaying = false;
            break;
          case 'completed':
            console.info('AVPlayer completed');
            this.isWhiteNoisePlaying = false;
            break;
          case 'error':
            console.error('AVPlayer error state');
            this.isWhiteNoisePlaying = false;
            break;
        }
      });
      
      this.avPlayer.on('error', (err) => {
         console.error(`AVPlayer error event: ${JSON.stringify(err)}`);
         this.isWhiteNoisePlaying = false;
      });
      
      // Initial trigger
      const context = getContext(this) as common.UIAbilityContext;
      try {
        const fileDescriptor = await context.resourceManager.getRawFd('rain.mp3');
        console.info(`Initial load fd: ${fileDescriptor.fd}, offset: ${fileDescriptor.offset}, length: ${fileDescriptor.length}`);
        this.avPlayer.fdSrc = fileDescriptor;
      } catch (err) {
        console.error(`Failed to get rawFd: ${JSON.stringify(err)}`);
        promptAction.showToast({ message: '音频文件加载失败' });
      }
      
    } catch (e) {
      console.error(`Failed to init player: ${e.message}`);
    }
  }

  private async toggleWhiteNoise(): Promise<void> {
    if (!this.avPlayer) {
      console.info('Initializing AVPlayer from toggle');
      await this.initAVPlayer();
    } else {
       console.info(`Toggling white noise, current state: ${this.avPlayer.state}`);
       if (this.avPlayer.state === 'playing') {
         await this.avPlayer.pause();
       } else if (this.avPlayer.state === 'paused' || this.avPlayer.state === 'prepared' || this.avPlayer.state === 'stopped') {
         await this.avPlayer.play();
       } else {
         console.info('Resetting AVPlayer');
         await this.avPlayer.reset();
         // The 'idle' state handler will reload the source
       }
    }
  }

  private async releaseAVPlayer(): Promise<void> {
    if (this.avPlayer) {
      try {
        await this.avPlayer.release();
      } catch (e) {}
      this.avPlayer = undefined;
      this.isWhiteNoisePlaying = false;
    }
  }

  @Builder
  QuoteCard() {
    Column() {
      // Top Icon
      Row() {
        Text('❝')
          .fontSize(24)
          .fontColor('#E5E7EB') // Light gray
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .padding({ left: 4 })

      // Text
      Text(this.currentQuote.text)
        .fontSize(16)
        .fontStyle(FontStyle.Italic)
        .fontColor('#374151')
        .textAlign(TextAlign.Center)
        .lineHeight(26)
        .margin({ top: 8, bottom: 12 })
        .width('90%')
      
      // Author
      Text(`— ${this.currentQuote.author}`)
        .fontSize(12)
        .fontColor('#9CA3AF')
        .margin({ bottom: 8 })
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(10)
    .borderRadius(20)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
    .opacity(this.quoteOpacity)
    .scale({ x: this.quoteScale, y: this.quoteScale })
    .onClick(() => this.refreshQuote())
  }
}

@Component
struct ToolCardItem {
  @Prop title: string = '';
  @Prop subtitle: string = '';
  @Prop bgColor: string = '#FFFFFF';
  @Prop emoji: string = '';
  action: () => void = () => {};

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text(this.emoji)
          .fontSize(24)
      }
      .width(48)
      .height(48)
      .borderRadius(24)
      .backgroundColor(this.bgColor)
      .margin({ bottom: 12 })

      Text(this.title)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonConstants.COLOR_PRIMARY)
        .margin({ bottom: 4 })
      
      Text(this.subtitle)
        .fontSize(12)
        .fontColor(CommonConstants.COLOR_SECONDARY)
    }
    .width('100%')
    .height(140)
    .backgroundColor(CommonConstants.COLOR_CARD)
    .borderRadius(24)
    .justifyContent(FlexAlign.Center)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
    .onClick(() => {
      this.action();
    })
  }
}
