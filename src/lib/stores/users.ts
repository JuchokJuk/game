import type { DataConnection } from "peerjs";
import { writable } from "svelte/store";

export type User = {
	UUID: string;
	peerUUID: string;
	position: [number, number, number];
	connection?: DataConnection;
};

export const users = writable<User[]>([]);
