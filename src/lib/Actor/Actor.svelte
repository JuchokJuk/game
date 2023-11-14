<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import { actor } from './ActorStore';

	let worker: Worker;
	let video: HTMLVideoElement;
	let requestId: number;
	let ctx: OffscreenCanvasRenderingContext2D;

	function startWebCam() {
		if (navigator.mediaDevices.getUserMedia) {
			navigator.mediaDevices
				.getUserMedia({ video: true })
				.then((stream) => {
					video.srcObject = stream;
				})
				.catch((error) => {
					console.warn(error);
				});
		}
	}

	function loop() {
		ctx.drawImage(video, 0, 0, ctx.canvas.width, ctx.canvas.height);
		const imData = ctx.getImageData(0, 0, ctx.canvas.width, ctx.canvas.height);
		worker.postMessage(imData.data.buffer, [imData.data.buffer]);
	}

	onMount(() => {
		ctx = new OffscreenCanvas(640, 480).getContext('2d') as OffscreenCanvasRenderingContext2D;

		worker = new Worker(new URL('./worker.ts', import.meta.url), {
			type: 'module'
		});

		worker.onmessage = (event) => {
			if (event.data.action === 'takeFaces') {
				if (event.data.payload.length) {
					$actor = event.data.payload[0].keypoints;
				}
				requestId = video.requestVideoFrameCallback(loop);
			}
			if (event.data.action === 'start') {
				requestId = video.requestVideoFrameCallback(loop);
			}
		};

		startWebCam();
	});

	onDestroy(() => {
		if (requestId !== undefined) {
			video.cancelVideoFrameCallback(requestId);
		}
		if (video) {
			const stream = video.srcObject as MediaStream | null;
			if (stream) {
				const tracks = stream.getTracks();
				tracks.forEach((track) => track.stop());
				video.srcObject = null;
			}
		}
	});
</script>

<!-- svelte-ignore a11y-media-has-caption -->
<video bind:this={video} autoplay />

<style lang="scss">
	video {
		display: none;
		position: fixed;
		top: 0;
		left: 0;
	}
</style>
