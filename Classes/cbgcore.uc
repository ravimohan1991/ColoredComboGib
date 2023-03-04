class cbgcore extends ShockCore;

function bool UseAmmo(int AmountNeeded)
{
	return True;
}

defaultproperties
{
	PickupMessage="You picked up a Combogib Core."
	ItemName="Combogib Core"
	MaxAmmo=50
	AmmoAmount=50
}