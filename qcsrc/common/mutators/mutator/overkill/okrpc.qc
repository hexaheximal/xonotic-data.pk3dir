#include "okrpc.qh"

#ifdef SVQC

void W_OverkillRocketPropelledChainsaw_Explode(entity this, entity directhitentity)
{
	this.event_damage = func_null;
	this.takedamage = DAMAGE_NO;

	RadiusDamage(this, this.realowner, WEP_CVAR_PRI(okrpc, damage), WEP_CVAR_PRI(okrpc, edgedamage), WEP_CVAR_PRI(okrpc, radius), NULL, NULL, WEP_CVAR_PRI(okrpc, force), this.projectiledeathtype, this.weaponentity_fld, directhitentity);

	delete(this);
}

void W_OverkillRocketPropelledChainsaw_Explode_think(entity this)
{
	W_OverkillRocketPropelledChainsaw_Explode(this, NULL);
}

void W_OverkillRocketPropelledChainsaw_Touch (entity this, entity toucher)
{
	if(WarpZone_Projectile_Touch(this, toucher))
		if(wasfreed(this))
			return;

	W_OverkillRocketPropelledChainsaw_Explode(this, toucher);
}

void W_OverkillRocketPropelledChainsaw_Damage(entity this, entity inflictor, entity attacker, float damage, int deathtype, .entity weaponentity, vector hitloc, vector force)
{
	if (this.health <= 0)
		return;

	if (!W_CheckProjectileDamage(inflictor.realowner, this.realowner, deathtype, -1)) // no exceptions
		return; // g_projectiles_damage says to halt

	this.health = this.health - damage;

	if (this.health <= 0)
		W_PrepareExplosionByDamage(this, attacker, W_OverkillRocketPropelledChainsaw_Explode_think);
}

void W_OverkillRocketPropelledChainsaw_Think(entity this)
{
	if(this.cnt <= time)
	{
		delete(this);
		return;
	}

	float myspeed = vlen(this.velocity);
	float myspeed_accel = myspeed * sys_frametime;
	vector mydir = normalize(this.velocity);

	tracebox(this.origin, this.mins, this.maxs, this.origin + mydir * (2 * myspeed_accel), MOVE_NORMAL, this);
	if(IS_PLAYER(trace_ent))
		Damage(trace_ent, this, this.realowner, WEP_CVAR_PRI(okrpc, damage2), this.projectiledeathtype, this.weaponentity_fld, this.origin, normalize(this.origin - trace_ent.origin) * WEP_CVAR_PRI(okrpc, force));

	this.velocity = mydir * (myspeed + (WEP_CVAR_PRI(okrpc, speedaccel) * sys_frametime));

	UpdateCSQCProjectile(this);
	this.nextthink = time;
}

void W_OverkillRocketPropelledChainsaw_Attack (Weapon thiswep, entity actor, .entity weaponentity)
{
	entity missile = spawn(); //WarpZone_RefSys_SpawnSameRefSys(actor);
	entity flash = spawn ();

	W_DecreaseAmmo(thiswep, actor, WEP_CVAR_PRI(okrpc, ammo), weaponentity);
	W_SetupShot_ProjectileSize(actor, weaponentity, '-3 -3 -3', '3 3 3', false, 5, SND_ROCKET_FIRE, CH_WEAPON_A, WEP_CVAR_PRI(okrpc, damage), WEP_OVERKILL_RPC.m_id);
	Send_Effect(EFFECT_ROCKET_MUZZLEFLASH, w_shotorg, w_shotdir * 1000, 1);
	PROJECTILE_MAKETRIGGER(missile);

	missile.owner = missile.realowner = actor;
	missile.bot_dodge = true;
	missile.bot_dodgerating = WEP_CVAR_PRI(okrpc, damage) * 2;

	missile.takedamage = DAMAGE_YES;
	missile.damageforcescale = WEP_CVAR_PRI(okrpc, damageforcescale);
	missile.health = WEP_CVAR_PRI(okrpc, health);
	missile.event_damage = W_OverkillRocketPropelledChainsaw_Damage;
	missile.damagedbycontents = true;
	IL_PUSH(g_damagedbycontents, missile);
	set_movetype(missile, MOVETYPE_FLY);

	missile.projectiledeathtype = WEP_OVERKILL_RPC.m_id;
	missile.weaponentity_fld = weaponentity;
	setsize (missile, '-3 -3 -3', '3 3 3'); // give it some size so it can be shot

	setorigin(missile, w_shotorg - v_forward * 3); // move it back so it hits the wall at the right point
	W_SetupProjVelocity_Basic(missile, WEP_CVAR_PRI(okrpc, speed), 0);

	settouch(missile, W_OverkillRocketPropelledChainsaw_Touch);

	setthink(missile, W_OverkillRocketPropelledChainsaw_Think);
	missile.cnt = time + WEP_CVAR_PRI(okrpc, lifetime);
	missile.nextthink = time;
	missile.flags = FL_PROJECTILE;
	IL_PUSH(g_projectiles, missile);
	IL_PUSH(g_bot_dodge, missile);

	CSQCProjectile(missile, true, PROJECTILE_RPC, false);

	setmodel(flash, MDL_RPC_MUZZLEFLASH); // precision set below
	SUB_SetFade (flash, time, 0.1);
	flash.effects = EF_ADDITIVE | EF_FULLBRIGHT | EF_LOWPRECISION;
	W_AttachToShotorg(actor, weaponentity, flash, '5 0 0');

	MUTATOR_CALLHOOK(EditProjectile, actor, missile);
}

METHOD(OverkillRocketPropelledChainsaw, wr_aim, void(entity thiswep, entity actor, .entity weaponentity))
{
    PHYS_INPUT_BUTTON_ATCK(actor) = bot_aim(actor, weaponentity, WEP_CVAR_PRI(okrpc, speed), 0, WEP_CVAR_PRI(okrpc, lifetime), false);
}

METHOD(OverkillRocketPropelledChainsaw, wr_think, void(entity thiswep, entity actor, .entity weaponentity, int fire))
{
	if ((WEP_CVAR_SEC(okrpc, refire_type) == 1) && (fire & 2) && (time >= actor.jump_interval))
	{
		// Secondary uses it's own refire timer if refire_type is 1.
		actor.jump_interval = time + WEP_CVAR_SEC(okrpc, refire) * W_WeaponRateFactor(actor);
		BLASTER_SECONDARY_ATTACK(okrpc, actor, weaponentity);
		if ((actor.(weaponentity).wframe == WFRAME_IDLE) ||
			(actor.(weaponentity).wframe == WFRAME_FIRE2))
		{
			// Set secondary fire animation.
			vector a = '0 0 0';
			actor.(weaponentity).wframe = WFRAME_FIRE2;
			a = actor.(weaponentity).anim_fire2;
			a.z *= g_weaponratefactor;
			FOREACH_CLIENT(true, LAMBDA(
				if (it == actor || (IS_SPEC(it) && it.enemy == actor))
				{
					wframe_send(it, actor.(weaponentity), a, true);
				}
			));
			animdecide_setaction(actor, ANIMACTION_SHOOT, true);
		}
	}
	if (WEP_CVAR(okrpc, reload_ammo) && actor.(weaponentity).clip_load < WEP_CVAR_PRI(okrpc, ammo))
	{
		// Forced reload
		thiswep.wr_reload(thiswep, actor, weaponentity);
		return;
	}
	if (fire & 1) // Primary attack
	{
		if (!weapon_prepareattack(thiswep, actor, weaponentity, false, WEP_CVAR_PRI(okrpc, refire)))
		{
			return;
		}
		W_OverkillRocketPropelledChainsaw_Attack(thiswep, actor, weaponentity);
		weapon_thinkf(actor, weaponentity, WFRAME_FIRE1, WEP_CVAR_PRI(okrpc, animtime), w_ready);
		return;
	}
	if ((fire & 2) && (WEP_CVAR_SEC(okrpc, refire_type) == 0)) // Secondary attack
	{
		if (!weapon_prepareattack(thiswep, actor, weaponentity, false, WEP_CVAR_SEC(okrpc, refire)))
		{
			return;
		}
		BLASTER_SECONDARY_ATTACK(okrpc, actor, weaponentity);
		weapon_thinkf(actor, weaponentity, WFRAME_FIRE2, WEP_CVAR_SEC(okrpc, animtime), w_ready);
	}
}

METHOD(OverkillRocketPropelledChainsaw, wr_checkammo1, bool(entity thiswep, entity actor, .entity weaponentity))
{
	float ammo_amount = GetResourceAmount(actor, thiswep.ammo_type) >= WEP_CVAR_PRI(okrpc, ammo);
	ammo_amount += actor.(weaponentity).(weapon_load[WEP_OVERKILL_RPC.m_id]) >= WEP_CVAR_PRI(okrpc, ammo);
	return ammo_amount;
}

METHOD(OverkillRocketPropelledChainsaw, wr_checkammo2, bool(entity thiswep, entity actor, .entity weaponentity))
{
	float ammo_amount = GetResourceAmount(actor, thiswep.ammo_type) >= WEP_CVAR_SEC(okrpc, ammo);
	ammo_amount += actor.(weaponentity).(weapon_load[WEP_OVERKILL_RPC.m_id]) >= WEP_CVAR_SEC(okrpc, ammo);
	return ammo_amount;
}

METHOD(OverkillRocketPropelledChainsaw, wr_reload, void(entity thiswep, entity actor, .entity weaponentity))
{
    W_Reload(actor, weaponentity, WEP_CVAR_PRI(okrpc, ammo), SND_RELOAD);
}

METHOD(OverkillRocketPropelledChainsaw, wr_suicidemessage, Notification(entity thiswep))
{
    if((w_deathtype & HITTYPE_BOUNCE) || (w_deathtype & HITTYPE_SPLASH))
        return WEAPON_OVERKILL_RPC_SUICIDE_SPLASH;
    else
        return WEAPON_OVERKILL_RPC_SUICIDE_DIRECT;
}

METHOD(OverkillRocketPropelledChainsaw, wr_killmessage, Notification(entity thiswep))
{
    if(w_deathtype & HITTYPE_SECONDARY)
        return WEAPON_BLASTER_MURDER;
    else if((w_deathtype & HITTYPE_BOUNCE) || (w_deathtype & HITTYPE_SPLASH))
        return WEAPON_OVERKILL_RPC_MURDER_SPLASH;
    else
        return WEAPON_OVERKILL_RPC_MURDER_DIRECT;
}

#endif

#ifdef CSQC

METHOD(OverkillRocketPropelledChainsaw, wr_impacteffect, void(entity thiswep, entity actor))
{
    vector org2;
    org2 = w_org + w_backoff * 12;
    pointparticles(EFFECT_ROCKET_EXPLODE, org2, '0 0 0', 1);
    if(!w_issilent)
        sound(actor, CH_SHOTS, SND_ROCKET_IMPACT, VOL_BASE, ATTEN_NORM);
}

#endif