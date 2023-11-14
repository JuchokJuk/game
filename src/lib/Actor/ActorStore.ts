import { writable } from 'svelte/store';

export type Point = { x: number; y: number; z: number };

export const actor = writable<Point[]>([]);
