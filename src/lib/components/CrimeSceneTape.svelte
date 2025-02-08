<script>
  import { onMount } from 'svelte';

  let tapeWidth;
  let tapeHeight;
  let tapeColor = '#FFF200';
  let textColor = '#000000';

  onMount(() => {
    const updateSize = () => {
      tapeWidth = window.innerWidth;
      tapeHeight = Math.min(80, window.innerHeight * 0.1);
    };

    updateSize();
    window.addEventListener('resize', updateSize);

    return () => {
      window.removeEventListener('resize', updateSize);
    };
  });
</script>

<div class="crime-scene-tape">
  <svg width={tapeWidth} height={tapeHeight}>
    <defs>
      <filter id="noise" x="0%" y="0%" width="100%" height="100%">
        <feTurbulence type="fractalNoise" baseFrequency="0.5" numOctaves="2" result="noise"/>
        <feDisplacementMap in="SourceGraphic" in2="noise" scale="3" xChannelSelector="R" yChannelSelector="G"/>
      </filter>
    </defs>
    <rect width={tapeWidth} height={tapeHeight} fill={tapeColor} filter="url(#noise)"/>
    <g class="tape-text-container">
      <text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" fill={textColor} font-size="24" font-weight="bold" class="tape-text">
        CRIME SCENE - DO NOT CROSS
      </text>
    </g>
  </svg>
</div>

<style>
  .crime-scene-tape {
    position: absolute;
    top: 50%;
    left: 0;
    transform: translateY(-50%) rotate(-5deg);
    z-index: 30;
    width: 100%;
    overflow: hidden;
  }

  .tape-text-container {
    animation: waver 5s ease-in-out infinite;
  }

  .tape-text {
    font-family: 'Impact', sans-serif;
    letter-spacing: 2px;
  }

  @keyframes waver {
    0%, 100% { transform: translateY(0) rotate(0); }
    50% { transform: translateY(-2px) rotate(2deg); }
  }

  @media (max-width: 768px) {
    .tape-text {
      font-size: 18px;
    }
  }
</style>
