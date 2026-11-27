@Component
export struct DeviceScanView {
  @Prop @Watch('redraw') isScanning: boolean = true;
  @Prop @Watch('redraw') boxSize: number = 200;
  @Prop @Watch('redraw') scanColor: string = '#FF4CAF50';

  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  private waveProgress: number = 0;
  private cancelAnim?: () => void;

  build() {
    Canvas(this.context)
      .width(`${this.boxSize}vp`)
      .height(`${this.boxSize}vp`)
      .onReady(() => this.startAnim())
  }

  aboutToDisappear(): void {
    this.stopAnim();
  }

  private startAnim(): void {
    this.stopAnim();
    const anim = this.getUIContext().createAnimator({
      duration: 3000,
      easing: 'linear',
      delay: 0,
      fill: 'none',
      direction: 'normal',
      iterations: -1,   // 无限循环
      begin: 0,
      end: 1
    });
    anim.onFrame = (progress: number): void => {
      this.waveProgress = progress % 1;
      this.draw();
    };
    anim.play();
    this.cancelAnim = (): void => { anim.cancel(); };
  }

  private stopAnim(): void {
    this.cancelAnim?.();
    this.cancelAnim = undefined;
  }

  private redraw(): void {
    this.draw();
  }

  private withAlpha(color: string, alpha: number): string {
    if (color.startsWith('#')) {
      let hex = color.slice(1);
      if (hex.length === 6) {
        hex = 'FF' + hex;
      }
      if (hex.length === 8) {
        const a = parseInt(hex.slice(0, 2), 16) / 255;
        const r = parseInt(hex.slice(2, 4), 16);
        const g = parseInt(hex.slice(4, 6), 16);
        const b = parseInt(hex.slice(6, 8), 16);
        const finalAlpha = Math.round(a * alpha * 1000) / 1000;
        return `rgba(${r}, ${g}, ${b}, ${finalAlpha})`;
      }
    }
    const matched = color.match(/rgba?$([^)]+)$/);
    if (matched) {
      const parts = matched[1].split(',').map((v: string) => v.trim());
      const finalAlpha = Math.round(alpha * 1000) / 1000;
      return `rgba(${parts[0]}, ${parts[1]}, ${parts[2]}, ${finalAlpha})`;
    }
    return color;
  }

  private draw(): void {
    const ctx = this.context;
    const w = ctx.width;
    const h = ctx.height;
    if (w <= 0 || h <= 0) {
      return;
    }
    const centerX = w / 2;
    const centerY = h / 2;
    const maxRadius = Math.min(w, h) / 2;
    const dotRadius = 3 * Math.min(w, h) / this.boxSize; // 3vp 等比换算到画布坐标

    ctx.clearRect(0, 0, w, h);

    if (this.isScanning) {
      for (const offset of [0, 0.3, 0.6]) {
        const p = (this.waveProgress + offset) % 1;
        ctx.beginPath();
        ctx.arc(centerX, centerY, maxRadius * p, 0, Math.PI * 2);
        ctx.fillStyle = this.withAlpha(this.scanColor, 0.2 * (1 - p));
        ctx.fill();
      }
    }

    ctx.beginPath();
    ctx.arc(centerX, centerY, dotRadius, 0, Math.PI * 2);
    ctx.fillStyle = this.scanColor;
    ctx.fill();
  }

}
