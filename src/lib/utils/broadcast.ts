import { users } from "$lib/stores/users";
import { get } from "svelte/store";

export function broadcast(message: unknown) {
	get(users).forEach((user) => {
		user.connection?.send(JSON.stringify(message));
	});
}
