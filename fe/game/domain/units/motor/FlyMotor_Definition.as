package fe.game.domain.units.motor {

	// How a unit that can take to the air flies
	public class FlyMotor_Definition {
		public var stalkDistance:Number		= 500.0;	// Within this distance of the player, a flier with a target hovers instead of closing in
		public var dodge:Number				= 1.0;		// Multiplier of the unit's dexterity while flying
	}
}