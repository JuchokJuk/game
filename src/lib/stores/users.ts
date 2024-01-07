import { writable } from "svelte/store";

export type User = {
    UUID: string;
    peerUUID: string;
    position: [number, number, number];
}

export const users = writable<User[]>([]);
