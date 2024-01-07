import { initialPlayerPosition } from "$lib/constants/initialPlayerPosition";
import { writable } from "svelte/store";

export const playerPosition = writable(initialPlayerPosition);
