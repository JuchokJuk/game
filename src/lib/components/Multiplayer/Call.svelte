<script lang="ts">
	import type { User } from "$lib/stores/users";
	import type Peer from "peerjs";
	import { onMount } from "svelte";

	export let peer: Peer;
	export let stream: MediaStream;
	export let user: User;

	let audio: HTMLAudioElement;

	onMount(() => {
		const mediaConnection = peer.call(user.peerUUID, stream);

		mediaConnection.on("stream", (remoteStream) => {
			audio.srcObject = remoteStream;
		});

		const connection = peer.connect(user.peerUUID);

		connection.on("open", () => {
			user.connection = connection;
		});
	});
</script>

<audio bind:this={audio} autoplay />
