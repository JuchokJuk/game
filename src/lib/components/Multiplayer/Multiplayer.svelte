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

	const port = PUBLIC_PEER_SERVER_PORT ? Number(PUBLIC_PEER_SERVER_PORT) : undefined;

	let stream: MediaStream;

	let socket: WebSocket;
	let intervalId: NodeJS.Timeout;

	let peer: Peer;
	let UUID: string;

	const actions = {
		saveUsers: (data: { users: User[]; UUID: string }) => {
			$users = data.users;
			UUID = data.UUID;
		},
		addUser: (user: User) => {
			$users.push(user);
			$users = $users;
		},
		setUserPosition: (data: { UUID: string; position: [number, number, number] }) => {
			const user = $users.find((user) => user.UUID === data.UUID);
			if (!user) return;
			user.position = data.position;
			$users = $users;
		},
		removeUser: (userUUID: string) => {
			$users = $users.filter((user) => user.UUID !== userUUID);
		}
	};

	type Action = keyof typeof actions;
	type Message = { action: Action; payload: any };

	async function startWebCam() {
		stream = await navigator.mediaDevices.getUserMedia({
			audio: true
		});
	}

	async function connect() {
		peer = new Peer({ host: PUBLIC_PEER_SERVER_HOST, port });

		peer.on("connection", (connection) => {
			connection.on("data", (data) => {
				const message = JSON.parse(data as string) as Message;

				actions[message.action](message.payload);
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
				const message = JSON.parse(event.data) as Message;
				actions[message.action](message.payload);
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
	<Call {UUID} {peer} {stream} {user} />
{/each}
