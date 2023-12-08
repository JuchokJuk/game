import { writable } from "svelte/store";

export const volume = writable<number>(0);
