//ripped from botpack.arena
class cbg_Mut1 extends Mutator config(cgzpp22a);

var name WeaponName, AmmoName;
var string WeaponString, AmmoString;
var() config bool bAllowJumpBoots;
var() config bool bAllowScubaGear;
var() config bool bAllowFlashlight;
var() config bool bAllowSuits;
var() config bool bAllowHealthPickups;
var() config bool bAllowArmorItems;

function AddMutator(Mutator M)
{
	if ( M.IsA('Arena') )
	{
		log(M$" not allowed (already have an Arena mutator)");
		return; //only allow one arena mutator
	}
	Super.AddMutator(M);
}

//ripped from allweapons.u
function ModifyPlayer(Pawn Other)
{
	//log("cbg_Mut1: ModifyPlayer"@Other);

	GiveWeapon( Other, "cgzpp22a.cbg" );

	if ( NextMutator != None )
		NextMutator.ModifyPlayer(Other);
}

function GiveWeapon(Pawn PlayerPawn, string aClassName )
{
	local class<Weapon> WeaponClass;
	local Weapon NewWeapon;

	WeaponClass = class<Weapon>(DynamicLoadObject(aClassName, class'Class'));

	if( PlayerPawn.FindInventoryType(WeaponClass) != None )
		return;
	newWeapon = Spawn(WeaponClass);
	if( newWeapon != None )
	{
		newWeapon.RespawnTime = 0.0;
		newWeapon.GiveTo(PlayerPawn);
		newWeapon.bHeldItem = true;
		newWeapon.GiveAmmo(PlayerPawn);
		newWeapon.SetSwitchPriority(PlayerPawn);
		newWeapon.WeaponSet(PlayerPawn);
		newWeapon.AmbientGlow = 0;
		if ( PlayerPawn.IsA('PlayerPawn') )
			newWeapon.SetHand(PlayerPawn(PlayerPawn).Handedness);
		else
			newWeapon.GotoState('Idle');
		PlayerPawn.Weapon.GotoState('DownWeapon');
		PlayerPawn.PendingWeapon = None;
		PlayerPawn.Weapon = newWeapon;
	}
}


function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	//log("cbg_Mut1: CheckReplacement"@Other);

	if ( Other.IsA('Weapon') && !Other.IsA(WeaponName) )
	{
		return false;
	}

	//contributed this code for fnn now I'm finally adding it here --snowguy 21b
	if ( Other.IsA('Pickup') && !Other.IsA(AmmoName) )
	{
		if( bAllowHealthPickups )
		{
			if( Other.IsA('MedBox') || Other.IsA('HealthPack') || Other.IsA('HealthVial') )
			{
				return true;
			}
		}

		if( bAllowArmorItems )
		{
			if( Other.IsA('ThighPads') || Other.IsA('Armor2') || Other.IsA('UT_ShieldBelt') )
				return true;
		}

		if( Other.IsA('UT_Jumpboots') && bAllowJumpBoots )
			return true;

		if( Other.IsA('SCUBAGear') && bAllowScubaGear )
			return true;

		if( bAllowFlashlight && Other.IsA('Flashlight'))
			return true;

		if( Other.IsA('Suits') && bAllowSuits )
			return true;

		return false;
	}

	bSuperRelevant = 0;
	return true;
}

defaultproperties
{
	WeaponName=cbg
	AmmoName=cbgcore
	WeaponString="cgzpp22a.cbg"
	AmmoString="cgzpp22a.cbgcore"
	DefaultWeapon=class'cgzpp22a.cbg'
	bAllowJumpBoots=True
	bAllowScubaGear=True
	bAllowFlashlight=False
	bAllowSuits=True
	bAllowHealthPickups=False
	bAllowArmorItems=False
}