package fe.unit.attack {

	// An attack a unit can perform
	public interface IAttack {
		function tick():void;		// Called every AI tick for each of a unit's attacks; Executes the attack if conditions are met
	}
}