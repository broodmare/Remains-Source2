package fe.unit.attack.system {

	// One way an AI unit can hurt its target
	public interface IAttack {
		function tick():void;		// Runs every tick the unit's AI is active; the attack decides whether it strikes
	}
}