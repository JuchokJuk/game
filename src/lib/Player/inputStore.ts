import { writable } from 'svelte/store';

export type Input = undefined | "keyboard" | "touch";

export const input = writable<Input>();
