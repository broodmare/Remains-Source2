package fe.game.domain.location.factories {

	// An opening between two neighbouring rooms, smallest size determines the size of the connection
	public class RoomConnection {

		public var slot:int;			// Slot index [Hor: 0-5 Top to bottom, Vert: 0-4 Left to right]
		public var openingSize:int;		// Size in tiles

		public function RoomConnection(slot_:int, openingSize_:int) {
			slot		= slot_;
			openingSize	= openingSize_;
		}
	}
}