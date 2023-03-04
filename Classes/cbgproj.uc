class cbgproj extends ShockProj;


//Function from Botpack.ShockProj first arg to HurtRadius originally set to Damage*3
//Overide here to change damagetype of combos to ShockCombo for combo kill detection
function SuperExplosion()
{
    HurtRadius(Damage*3, 250, 'combo', MomentumTransfer*2, Location );
    
    Spawn(Class'ut_ComboRing',,'',Location, Instigator.ViewRotation);
    PlaySound(ExploSound,,20.0,,2000,0.6);  
    
    Destroy(); 
}

defaultproperties
{
     Damage=1000
     MyDamageType=ShockBall
}