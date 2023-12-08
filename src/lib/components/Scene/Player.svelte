<script lang="ts">
	import { Vector3, Quaternion, Euler } from "three";
	import type { RigidBody as RapierRigidBody } from "@dimforge/rapier3d-compat";
	import { T, useFrame } from "@threlte/core";
	import { RigidBody, Collider } from "@threlte/rapier";
	import SecondOrderDynamics from "../SecondOrderDynamics";
	import { AudioListener } from "@threlte/extras";
	import { playerController } from "$lib/stores/playerController";
	import { UI } from "$lib/stores/UI";

	export let position: [number, number, number];

	let shakingStrength = 0;
	const shakingStrengthAnimation = new SecondOrderDynamics(3, 1, 0);

	let extraFov = 0;
	const extraFovAnimation = new SecondOrderDynamics(3, 1, 0);

	const walkingSpeed = 8;
	const jumStrength = 3;

	let rigidBody: RapierRigidBody;

	let rotation = new Quaternion();

	$: {
		const qx = new Quaternion();
		qx.setFromAxisAngle(new Vector3(0, 1, 0), $playerController.phi);
		const qz = new Quaternion();
		qz.setFromAxisAngle(new Vector3(1, 0, 0), $playerController.theta);

		const q = new Quaternion();
		q.multiply(qx);
		q.multiply(qz);

		rotation = q;
	}

	const walkLinvel = new Vector3(0, 0, 0);
	const horizontalWalkLinvel = new Vector3(0, 0, 0);
	const jumpImpulse = new Vector3(0, 0, 0);

	const startFov = 60;
	let speedZ = 0;
	let speedX = 0;

	let time = 0;

	useFrame(({ clock }, delta) => {
		time = clock.getElapsedTime();

		if (!rigidBody) return;

		const rigidBodyLinvel = rigidBody.linvel();

		speedZ = -Math.sin($playerController.angle) * $playerController.speed * walkingSpeed;
		speedX = Math.cos($playerController.angle) * $playerController.speed * walkingSpeed;

		walkLinvel.set(speedX, 0, speedZ);
		walkLinvel.applyEuler(new Euler(0, $playerController.phi, 0));

		horizontalWalkLinvel.set(walkLinvel.x, 0, walkLinvel.z);

		horizontalWalkLinvel.y = rigidBodyLinvel.y;
		rigidBody.setLinvel(horizontalWalkLinvel, true);

		const horizontalWalkLinvelLength = Math.sqrt(rigidBodyLinvel.x ** 2 + rigidBodyLinvel.z ** 2);

		shakingStrength = shakingStrengthAnimation.update(
			delta,
			grounded ? horizontalWalkLinvelLength : 0
		);

		extraFov = extraFovAnimation.update(delta, horizontalWalkLinvelLength * 0.5);

		if (grounded) {
			jumpImpulse.set(0, $playerController.jump ? jumStrength : 0, 0);
			rigidBody.applyImpulse(jumpImpulse, true);
		}
	});

	let grounded = false;
	let groundsSensored = 0;

	$: {
		if (groundsSensored === 0) grounded = false;
		else grounded = true;
	}
</script>

<T.Group {position}>
	<RigidBody bind:rigidBody enabledRotations={[false, false, false]} gravityScale={2}>
		<T.PerspectiveCamera
			makeDefault
			fov={startFov + extraFov}
			quaternion={[rotation.x, rotation.y, rotation.z, rotation.w]}
			position={[0, 0.75 + shakingStrength * Math.sin(time * 12) * 0.003, 0]}
		>
			{#if $UI === "playing"}
				<AudioListener />
			{/if}
		</T.PerspectiveCamera>
		<Collider shape={"capsule"} args={[0.5, 0.5]} />

		<T.Group position.y={-0.875}>
			<Collider
				shape={"ball"}
				args={[0.25]}
				sensor
				on:sensorenter={() => (groundsSensored += 1)}
				on:sensorexit={() => (groundsSensored -= 1)}
			/>
		</T.Group>
	</RigidBody>
</T.Group>
