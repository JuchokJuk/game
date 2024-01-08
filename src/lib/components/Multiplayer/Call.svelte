<script lang="ts">
	import { playerPosition } from "$lib/stores/playerPosition";
	import type { User } from "$lib/stores/users";
	import type Peer from "peerjs";
	import { onDestroy, onMount } from "svelte";

	export let UUID: string;
	export let peer: Peer;
	export let stream: MediaStream;
	export let user: User;

	let audio: HTMLAudioElement;

	let requestId: number | undefined;

	onMount(() => {
		const mediaConnection = peer.call(user.peerUUID, stream);

		const conn = peer.connect(user.peerUUID);

		function loop() {
			conn.send(
				JSON.stringify({
					action: "setUserPosition",
					payload: { UUID, position: $playerPosition }
				})
			);
			requestId = requestAnimationFrame(loop);
		}

		conn.on("open", () => {
			requestId = requestAnimationFrame(loop);
		});

		mediaConnection.on("stream", (remoteStream) => {
			audio.srcObject = remoteStream;
		});
	});

	onDestroy(() => {
		if (requestId) cancelAnimationFrame(requestId);
	});
</script>

<audio bind:this={audio} autoplay />
