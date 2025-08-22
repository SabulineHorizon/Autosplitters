// Written by SabulineHorizon
// This can be done much more cleanly, but I just wanted to throw something together quickly for personal use
// It hasn't been tested very thoroughly yet, so some pointers might break

state("dogwalk") {
	// These pointers are for version 1.0.2 from Steam
	int trigger: 0x5CB8BD0, 0x28, 0x8, 0x78, 0x110;	// 9 main menu, 5 gameplay, 7 transition, sometimes 0?
	float posX: 0x5CB5540, 0x310, 0x188, 0x18, 0x68, 0x28, 0xE8, 0x40C; // Player (dog) position X
	float posZ: 0x5CB5540, 0x310, 0x188, 0x18, 0x68, 0x28, 0xE8, 0x414; // Player (dog) position Z
	float camX: 0x5CB5540, 0x310, 0x8E8, 0x140, 0x40C; // Camera position X
	float camZ: 0x5CB5540, 0x310, 0x8E8, 0x140, 0x414; // Camera position Z
}

reset {
	// Reset on the exact same condition as start
	return(
		(Math.Abs(old.posX - (-2.539)) < 0.01) &&
		(Math.Abs(old.posZ - (1.144)) < 0.01) &&
		(Math.Abs(old.camX - (-2.984)) < 0.01) &&
		(Math.Abs(old.camZ - (11.773)) < 0.01) &&
		(Math.Abs(current.camX - (-2.984)) >= 0.01)
	);
}

start {
	// Start if camera moves while it's in the title menu position
	return(
		(Math.Abs(old.posX - (-2.539)) < 0.01) &&
		(Math.Abs(old.posZ - (1.144)) < 0.01) &&
		(Math.Abs(old.camX - (-2.984)) < 0.01) &&
		(Math.Abs(old.camZ - (11.773)) < 0.01) &&
		(Math.Abs(current.camX - (-2.984)) >= 0.01)
	);
}

split {
	// Split (end timer) if trigger address changes value while dog is in the final cutscene start position
	return(
		old.trigger == 5 && current.trigger != 5 &&
		(Math.Abs(current.posX - (-0.999)) < 0.01) &&
		(Math.Abs(current.posZ - (0.824)) < 0.01)
	);
}
