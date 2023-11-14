<script lang="ts">
	import { Vector3, Quaternion, Vector2 } from 'three';
	import { T, useFrame } from '@threlte/core';
	import { RigidBody, Collider } from '@threlte/rapier';
	import { clamp } from '../clamp';
	import SecondOrderDynamics from './SecondOrderDynamics';
	import { AudioListener } from '@threlte/extras';

	// import { playerPosition } from './playerPositionStore';

	export let position: [number, number, number];

	const speedXAnimation = new SecondOrderDynamics(3, 1, 0);
	const speedZAnimation = new SecondOrderDynamics(3, 1, 0);

	let shakingStrength = 0;
	const shakingStrengthAnimation = new SecondOrderDynamics(3, 1, 0);

	let extraFov = 0;
	const extraFovAnimation = new SecondOrderDynamics(3, 1, 0);

	const walkingSpeed = 12;
	const runningSpeed = 26;
	const jumStrength = 12;

	let rigidBody: any;

	import { jump, run, doubleForwardRun, forward, backward, left, right } from './controlsStore';

	let forwardPressed = false;

	function onKeyDown(e: KeyboardEvent) {
		if (e.code === 'KeyS') $backward = 1;
		if (e.code === 'KeyW') {
			// 1: нажали w, побежали
			$forward = 1;
			if (forwardPressed) {
				$doubleForwardRun = 1;
			}
		}
		if (e.code === 'KeyA') $left = 1;
		if (e.code === 'KeyD') $right = 1;
		if (e.code === 'Space') $jump = 1;
		if (e.code === 'ShiftLeft') $run = 1; // 0: нажали shift
	}

	function onKeyUp(e: KeyboardEvent) {
		if (e.code === 'KeyS') $backward = 0;
		if (e.code === 'KeyW') {
			// 2: отжали w остановились
			$forward = 0;
			$doubleForwardRun = 0;
			forwardPressed = true;
			setTimeout(() => {
				forwardPressed = false;
			}, 200);
		}
		if (e.code === 'KeyA') $left = 0;
		if (e.code === 'KeyD') $right = 0;
		if (e.code === 'Space') $jump = 0;
		if (e.code === 'ShiftLeft') {
			$run = 0;
			$doubleForwardRun = 0;
		}
	}

	let phi_ = 0;
	let theta_ = 0;
	let rotation = new Quaternion();

	function onPointerMove(e: PointerEvent) {
		const xh = e.movementX * 0.003;
		const yh = e.movementY * 0.003;

		phi_ += -xh * 1;
		theta_ = clamp(theta_ + -yh * 1, -Math.PI / 2, Math.PI / 2);

		const qx = new Quaternion();
		qx.setFromAxisAngle(new Vector3(0, 1, 0), phi_);
		const qz = new Quaternion();
		qz.setFromAxisAngle(new Vector3(1, 0, 0), theta_);

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

		const movingZDirection = $backward - $forward;
		const movingXDirection = $right - $left;

		speedZ = speedZAnimation.update(
			delta,
			movingZDirection * ($run || $doubleForwardRun ? runningSpeed : walkingSpeed)
		);
		speedX = speedXAnimation.update(delta, movingXDirection * walkingSpeed);

		walkLinvel.set(speedX, 0, speedZ);
		walkLinvel.applyQuaternion(rotation);

		horizontalWalkLinvel.set(walkLinvel.x, 0, walkLinvel.z);

		// todo: fix diagonal speed boost
		// todo: allow walk forward when looking down

		horizontalWalkLinvel.y = rigidBodyLinvel.y;
		rigidBody.setLinvel(horizontalWalkLinvel, true);

		const horizontalWalkLinvelLength = Math.sqrt(rigidBodyLinvel.x ** 2 + rigidBodyLinvel.z ** 2);

		shakingStrength = shakingStrengthAnimation.update(
			delta,
			grounded ? horizontalWalkLinvelLength : 0
		);

		extraFov = extraFovAnimation.update(delta, horizontalWalkLinvelLength * 0.5);

		if (grounded) {
			jumpImpulse.set(0, $jump * jumStrength, 0);
			rigidBody.applyImpulse(jumpImpulse, true);
		}

		// const position = rigidBody.translation();
		// if (Math.abs($playerPosition.x - position.x) > 4) $playerPosition.x = position.x;
		// if (Math.abs($playerPosition.z - position.z) > 4) $playerPosition.z = position.z;
	});

	let grounded = false;
	let groundsSensored = 0;

	$: {
		if (groundsSensored === 0) grounded = false;
		else grounded = true;
	}
</script>

<svelte:window
	on:keydown|stopPropagation|preventDefault={onKeyDown}
	on:keyup|stopPropagation|preventDefault={onKeyUp}
	on:pointermove={onPointerMove}
/>

<T.Group {position}>
	<RigidBody bind:rigidBody enabledRotations={[false, false, false]} gravityScale={10} ccd>
		<T.PerspectiveCamera
			makeDefault
			fov={startFov + extraFov}
			quaternion={[rotation.x, rotation.y, rotation.z, rotation.w]}
			position={[0, 0.75 + shakingStrength * Math.sin(time * 12) * 0.003, 0]}
		>
			<AudioListener />
		</T.PerspectiveCamera>
		<Collider shape={'capsule'} args={[0.5, 0.5]} />

		<T.Group position.y={-0.875}>
			<Collider
				shape={'ball'}
				args={[0.25]}
				sensor
				on:sensorenter={() => (groundsSensored += 1)}
				on:sensorexit={() => (groundsSensored -= 1)}
			/>
		</T.Group>
	</RigidBody>
</T.Group>
