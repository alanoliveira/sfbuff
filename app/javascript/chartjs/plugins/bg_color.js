export default {
  id: 'bgColor',
  beforeDraw: (chart, args, options) => {
    if(!options.color) return

    const { ctx } = chart;
    ctx.save();
    ctx.globalCompositeOperation = 'destination-over';
    ctx.fillStyle = options.color;
    ctx.fillRect(0, 0, chart.width, chart.height);
    ctx.restore();
  }
};
