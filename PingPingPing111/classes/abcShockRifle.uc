class abcShockRifle extends ShockRifle;

var class<SuperShockBeam> RedBeamClass;
var class<SuperShockBeam> BlueBeamClass;
var class<Projectile> RedProjectileClass;
var class<Projectile> BlueProjectileClass;
var class<UT_RingExplosion> RedRingTraceHitExplosionClass;

simulated function PostBeginPlay()
{
	RedBeamClass = class<SuperShockBeam>(DynamicLoadObject("ColoredComboGib.SuperShockBeam_Red", class'Class'));
	BlueBeamClass = class<SuperShockBeam>(DynamicLoadObject("ColoredComboGib.SuperShockBeam_Blue", class'Class'));

	RedProjectileClass = class<Projectile>(DynamicLoadObject("ColoredComboGib.RedShockProj", class'Class'));
	BlueProjectileClass = class<Projectile>(DynamicLoadObject("ColoredComboGib.cbgproj", class'Class'));

	RedRingTraceHitExplosionClass = class<UT_RingExplosion>(DynamicLoadObject("ColoredComboGib.Red_RingExplosion2", class'Class'));

    super.PostBeginPlay();
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local PlayerPawn PlayerOwner;

	if (Other==None)
	{
		HitNormal = -X;
		HitLocation = Owner.Location + X*10000.0;
	}

	PlayerOwner = PlayerPawn(Owner);
	if ( PlayerOwner != None )
		PlayerOwner.ClientInstantFlash( -0.4, vect(450, 190, 650));
	SpawnEffect(HitLocation, Owner.Location + CalcDrawOffset() + (FireOffset.X + 20) * X + FireOffset.Y * Y + FireOffset.Z * Z);

	if ( ShockProj(Other)!=None )
	{
		AmmoType.UseAmmo(2);
		ShockProj(Other).SuperExplosion();
	}
	else
	{
	    if(Pawn(Owner).PlayerReplicationInfo.Team == 0)
	    {
			Spawn(RedRingTraceHitExplosionClass,,, HitLocation+HitNormal*8,rotator(HitNormal));
		}
		else
		{
		    Spawn(class'ut_RingExplosion5',,, HitLocation+HitNormal*8,rotator(HitNormal));
        }
	}

	if ( (Other != self) && (Other != Owner) && (Other != None) )
		Other.TakeDamage(HitDamage, Pawn(Owner), HitLocation, 60000.0*X, MyDamageType);
}

function SpawnEffect(vector HitLocation, vector SmokeLocation)
{
	local SuperShockBeam Smoke;
	local Vector DVector;
	local int NumPoints;
	local rotator SmokeRotation;

	DVector = HitLocation - SmokeLocation;
	NumPoints = VSize(DVector)/135.0;
	if ( NumPoints < 1 )
		return;
	SmokeRotation = rotator(DVector);
	SmokeRotation.roll = Rand(65535);

    if(Pawn(Owner).PlayerReplicationInfo.Team == 0)
    {
		Smoke = Spawn(RedBeamClass,,,SmokeLocation,SmokeRotation);
	}
	else
	{
    	Smoke = Spawn(BlueBeamClass,,,SmokeLocation,SmokeRotation);
    }

    Smoke.MoveAmount = DVector/NumPoints;
	Smoke.NumPuffs = NumPoints - 1;
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;
	local PlayerPawn PlayerOwner;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);

	PlayerOwner = PlayerPawn(Owner);
	if ( PlayerOwner != None )
		PlayerOwner.ClientInstantFlash( -0.4, vect(450, 190, 650));

    if(Pawn(Owner).PlayerReplicationInfo.Team == 0)
    {
        Tracked = Spawn(RedProjectileClass, , , Start, AdjustedAim);
    }
    else
    {
        Tracked = Spawn(BlueProjectileClass, , , Start, AdjustedAim);// judicious use, from cgzpp22a, hehe hehe
    }

	if ( Level.Game.IsA('DeathMatchPlus') && DeathmatchPlus(Level.Game).bNoviceMode )
		Tracked = None; //no combo move
	return Tracked;
}

