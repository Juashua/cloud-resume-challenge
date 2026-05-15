/**
 * matrix.js - Gold Matrix rain on purple background
 * Very long streaks, very slight fade, medium-slow motion
 */
(function () {
  const canvas = document.getElementById('matrix-canvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');

  let width = window.innerWidth;
  let height = window.innerHeight;
  canvas.width = width;
  canvas.height = height;

  const chars = '0123456789-';
  const fontSize = 16;
  let columns = Math.floor(width / fontSize);

  // MEDIUM-SLOW drift: 0.16-0.36 rows per frame
  let drops = new Array(columns).fill(0).map(() => ({
    y: Math.random() * -80,
    speed: 0.16 + Math.random() * 0.20, // 0.16-0.36
  }));

  function handleResize() {
    width = window.innerWidth;
    height = window.innerHeight;
    canvas.width = width;
    canvas.height = height;
    columns = Math.floor(width / fontSize);
    drops = new Array(columns).fill(0).map(() => ({
      y: Math.random() * -80,
      speed: 0.16 + Math.random() * 0.20,
    }));
    ctx.fillStyle = '#461D7C';
    ctx.fillRect(0, 0, width, height);
  }

  window.addEventListener('resize', handleResize);

  function draw() {
    // Very slight fade
    ctx.fillStyle = 'rgba(70, 29, 124, 0.03)';
    ctx.fillRect(0, 0, width, height);

    ctx.font = fontSize + 'px monospace';
    ctx.textBaseline = 'top';

    for (let i = 0; i < columns; i++) {
      const drop = drops[i];
      const x = i * fontSize;
      const y = drop.y * fontSize;

      ctx.fillStyle = '#fce89a';
      ctx.shadowColor = '#fce89a';
      ctx.shadowBlur = 10;
      const char = chars.charAt(Math.floor(Math.random() * chars.length));
      ctx.fillText(char, x, y);
      ctx.shadowBlur = 0;

      // Medium-slow movement
      drop.y += drop.speed;

      if (y > height + fontSize * 80) {
        drop.y = Math.random() * -80;
        drop.speed = 0.16 + Math.random() * 0.20;
      }
    }

    requestAnimationFrame(draw);
  }

  ctx.fillStyle = '#461D7C';
  ctx.fillRect(0, 0, width, height);
  draw();
})();
