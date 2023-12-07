import { writable } from "svelte/store";

export type UI = "playing" | "waiting";

export const UI = writable<UI>("waiting");
