//================================================================================
// RedUT_ComboRing.
//================================================================================

class RedUT_ComboRing extends UT_ComboRing;

simulated function SpawnEffects ()
{
  local Actor A;

  if ( Level.bHighDetailMode &&  !Level.bDropDetail )
  {
    A = Spawn(Class'Red_ringexplosion4',self);
    A.RemoteRole = ROLE_None;
  }
  Spawn(Class'BigEnergyImpact',,,,rot(16384,0,0));
  A = Spawn(Class'RedExplo');
  A.RemoteRole = ROLE_None;
  A = Spawn(Class'RedShockrifleWave');
  A.RemoteRole = ROLE_None;
}

defaultproperties
{
    Skin=Texture'redring'
}
