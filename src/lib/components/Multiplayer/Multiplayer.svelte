<script lang="ts">
	import { onDestroy, onMount } from "svelte";
	import { send } from "./send";
	import Call from "./Call.svelte";
	import {
		PUBLIC_PEER_SERVER_HOST,
		PUBLIC_PEER_SERVER_PORT,
		PUBLIC_ROOM_SERVER_URL
	} from "$env/static/public";
	import Peer, { type MediaConnection } from "peerjs";
	import { users, type User } from "$lib/stores/users";
	import { UUID } from "$lib/stores/UUID";
	import { musicStarted } from "$lib/stores/musicStarted";

	const port = PUBLIC_PEER_SERVER_PORT ? Number(PUBLIC_PEER_SERVER_PORT) : undefined;

	let stream: MediaStream;

	let socket: WebSocket;
	let intervalId: NodeJS.Timeout;

	let peer: Peer;

	const socketActions = {
		saveUsers: (data: { users: User[]; UUID: string }) => {
			$users = data.users;
			$UUID = data.UUID;
		},
		addUser: (user: User) => {
			$users.push(user);
			$users = $users;
		},
		removeUser: (userUUID: string) => {
			$users = $users.filter((user) => user.UUID !== userUUID);
		}
	};

	const peerActions = {
		setUserPosition: (data: { UUID: string; position: [number, number, number] }) => {
			const user = $users.find((user) => user.UUID === data.UUID);
			if (!user) return;
			user.position = data.position;
			$users = $users;
		},
		toggleMusic: (musicStarted: boolean) => {
			$musicStarted = musicStarted;
		}
	};

	type PeerAction = keyof typeof peerActions;
	type SocketAction = keyof typeof socketActions;

	type PeerMessage = { action: PeerAction; payload: any };
	type SocketMessage = { action: SocketAction; payload: any };

	async function startWebCam() {
		stream = await navigator.mediaDevices.getUserMedia({
			audio: true
		});
	}

	async function connect() {
		peer = new Peer({ host: PUBLIC_PEER_SERVER_HOST, port });

		peer.on("connection", (connection) => {
			connection.on("data", (data) => {
				const message = JSON.parse(data as string) as PeerMessage;

				peerActions[message.action](message.payload);
			});
		});

		peer.on("call", (mediaConnection: MediaConnection) => {
			mediaConnection.answer(stream);
		});

		peer.on("open", (UUID: string) => {
			socket = new WebSocket(PUBLIC_ROOM_SERVER_URL);

			socket.onopen = () => {
				intervalId = setInterval(() => {
					send(socket, { action: "heartbeat", payload: null });
				}, 5000);

				send(socket, { action: "savePeerUUID", payload: UUID });
			};

			socket.onmessage = (event) => {
				const message = JSON.parse(event.data) as SocketMessage;
				socketActions[message.action](message.payload);
			};

			socket.onclose = () => {
				clearInterval(intervalId);
				$users = [];
			};
		});
	}

	function disconnect() {
		clearInterval(intervalId);
		socket.close();
		$users = [];
	}

	async function start() {
		await startWebCam();
		connect();
	}

	function reconnect() {
		disconnect();
		connect();
	}

	onMount(() => {
		start();
	});

	onDestroy(() => {
		clearInterval(intervalId);
		peer?.destroy();
	});
</script>

<svelte:window on:online={reconnect} on:offline={disconnect} />

{#each $users as user (user.peerUUID)}
	<Call {peer} {stream} {user} />
{/each}
