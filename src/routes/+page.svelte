<script>
  import { onMount } from 'svelte';
  import { writable } from 'svelte/store';
  import { goto } from '$app/navigation';
  import RainOverlay from '$lib/components/RainOverlay.svelte';
  import BloodSplatter from '$lib/components/BloodSplatter.svelte';
  import CrimeSceneTape from '$lib/components/CrimeSceneTape.svelte';

  export const userName = writable('');
  let heading;
  let name = '';
  let error = '';
  let isTransitioning = false;
  
  onMount(() => {
    if (heading) {
      heading.style.opacity = '1';
      heading.style.transform = 'translateY(0)';
      heading.style.transition = 'opacity 1s, transform 1s';
    }
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (name.trim() === '') {
      error = 'We need a name to proceed, dear guest.';
      return;
    }
    userName.set(name);
    isTransitioning = true;
    
    await new Promise(resolve => setTimeout(resolve, 3000));
    goto('/next-page');
  };
</script>

<svelte:head>
  <title>Crime Scene Investigation</title>
</svelte:head>

<div class="fixed inset-0 overflow-hidden bg-gray-900">
  <div class="mansion-container absolute inset-0 z-10 flex items-center justify-center">
    <div class="mansion w-full h-full" class:transitioning={isTransitioning}></div>
  </div>
  <div class="overlay absolute inset-0 z-20" class:transitioning={isTransitioning}></div>
  <RainOverlay />
  <BloodSplatter />
  
  <div class="absolute inset-0 z-40 flex flex-col items-center px-4" class:fade-out={isTransitioning}>
    <h1 
      bind:this={heading}
      class="text-5xl font-bold text-center mt-8 opacity-0 text-red-600 md:text-5xl text-4xl"
      style="transform: translateY(50px)"
    >
      Crime Scene Investigation
    </h1>

    <div class="flex flex-col items-center justify-center mt-16 text-gray-100">
      <h2 class="text-3xl font-bold mb-4">Welcome, Stranger...</h2>
      <p class="mb-6 text-lg">What shall we call you tonight?</p>
    </div>

    <CrimeSceneTape />
    
    <form on:submit={handleSubmit} class="flex flex-col items-center gap-4 mt-16 md:mt-16 mt-32">
      <input
        type="text"
        bind:value={name}
        placeholder="Enter your name"
        class="px-4 py-2 border border-gray-500 rounded-md bg-gray-800 text-gray-100 placeholder-gray-400 w-full max-w-xs"
      />
      {#if error}
        <p class="text-red-500 text-sm">{error}</p>
      {/if}
      <button
        type="submit"
        class="px-6 py-2 bg-red-600 hover:bg-red-700 rounded-md text-white font-medium w-full max-w-xs"
      >
        Continue
      </button>
    </form>
  </div>
</div>

<style>
  :global(body) {
    font-family: 'Georgia', serif;
    overflow: hidden;
  }

  .mansion-container {
    transform-origin: center center;
  }

  .mansion {
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 800 600'%3E%3Cpath d='M300,500 L300,250 L400,150 L500,250 L500,500 Z' stroke='%23ccc' stroke-width='4' fill='none'/%3E%3Cpath d='M280,500 L280,260 L400,140 L520,260 L520,500' stroke='%23bbb' stroke-width='3' fill='none'/%3E%3Cpath d='M340,500 L340,350 L400,350 L400,500 M440,500 L440,350 L460,350 L460,500' stroke='%23ccc' stroke-width='3' fill='none'/%3E%3Cpath d='M380,200 L400,170 L420,200 L420,230 L380,230 Z' stroke='%23ccc' stroke-width='3' fill='none'/%3E%3Cpath d='M350,300 h40 M410,300 h40 M350,400 h30 M420,400 h30' stroke='%23ccc' stroke-width='3' fill='none'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: center center;
    background-size: 60%;
    opacity: 0.4;
    transform: scale(0.8);
    transition: transform 3s ease-in, opacity 3s ease-in;
    transform-origin: center center;
  }

  .mansion.transitioning {
    transform: scale(8);
    opacity: 0.8;
  }

  .mansion::before {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at 50% 30%, rgba(255, 220, 150, 0.25) 0%, transparent 70%);
    pointer-events: none;
  }

  .mansion::after {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(180deg, 
      rgba(17, 24, 39, 0.2) 0%,
      rgba(17, 24, 39, 0.4) 30%,
      rgba(17, 24, 39, 0.6) 100%
    );
    pointer-events: none;
  }

  .overlay {
    background: black;
    opacity: 0;
    transition: opacity 3s ease-in;
    pointer-events: none;
  }

  .overlay.transitioning {
    opacity: 1;
  }

  .fade-out {
    transition: opacity 2s ease-in;
    opacity: 0;
  }
</style>
