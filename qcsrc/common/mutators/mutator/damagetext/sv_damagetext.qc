#include "sv_damagetext.qh"

AUTOCVAR(sv_damagetext, int, 2, "<= 0: disabled, >= 1: spectators, >= 2: players, >= 3: all players");

REGISTER_MUTATOR(damagetext, true);

#define SV_DAMAGETEXT_DISABLED()        (autocvar_sv_damagetext <= 0 /* disabled */)
#define SV_DAMAGETEXT_SPECTATORS_ONLY() (autocvar_sv_damagetext >= 1 /* spectators only */)
#define SV_DAMAGETEXT_PLAYERS()         (autocvar_sv_damagetext >= 2 /* players */)
#define SV_DAMAGETEXT_ALL()             (autocvar_sv_damagetext >= 3 /* all players */)
MUTATOR_HOOKFUNCTION(damagetext, PlayerDamaged) {
    if (SV_DAMAGETEXT_DISABLED()) return;
    const entity attacker = M_ARGV(0, entity);
    const entity hit = M_ARGV(1, entity); if (hit == attacker) return;
    const float health = M_ARGV(2, float);
    const float armor = M_ARGV(3, float);
    const int deathtype = M_ARGV(5, int);
    const float potential_damage = M_ARGV(6, float);
    const vector location = hit.origin;
    FOREACH_CLIENT(IS_REAL_CLIENT(it), LAMBDA(
        if (
            (SV_DAMAGETEXT_ALL()) ||
            (SV_DAMAGETEXT_PLAYERS() && it == attacker) ||
            (SV_DAMAGETEXT_SPECTATORS_ONLY() && IS_SPEC(it) && it.enemy == attacker) ||
            (SV_DAMAGETEXT_SPECTATORS_ONLY() && IS_OBSERVER(it))
        ) {
            int flags = 0;
            if (SAME_TEAM(hit, attacker)) flags |= DTFLAG_SAMETEAM;
            if (health >= DAMAGETEXT_SHORT_LIMIT) flags |= DTFLAG_BIG_HEALTH;
            if (armor >= DAMAGETEXT_SHORT_LIMIT) flags |= DTFLAG_BIG_ARMOR;
            if (potential_damage >= DAMAGETEXT_SHORT_LIMIT) flags |= DTFLAG_BIG_POTENTIAL;
            if (!armor) flags |= DTFLAG_NO_ARMOR;
            if (almost_equals_eps(armor + health, potential_damage, 5)) flags |= DTFLAG_NO_POTENTIAL;

            msg_entity = it;
            WriteHeader(MSG_ONE, damagetext);
            WriteEntity(MSG_ONE, hit);
            WriteCoord(MSG_ONE, location.x);
            WriteCoord(MSG_ONE, location.y);
            WriteCoord(MSG_ONE, location.z);
            WriteInt24_t(MSG_ONE, deathtype);
            WriteByte(MSG_ONE, flags);

            // we need to send a few decimal places to minimize errors when accumulating damage
            // sending them multiplied saves bandwidth compared to using WriteCoord,
            // however if the multiplied damage would be too much for (signed) short, we send an int24
            if (flags & DTFLAG_BIG_HEALTH) WriteInt24_t(MSG_ONE, health * DAMAGETEXT_PRECISION_MULTIPLIER);
            else WriteShort(MSG_ONE, health * DAMAGETEXT_PRECISION_MULTIPLIER);
            if (!(flags & DTFLAG_NO_ARMOR))
            {
                if (flags & DTFLAG_BIG_ARMOR) WriteInt24_t(MSG_ONE, armor * DAMAGETEXT_PRECISION_MULTIPLIER);
                else WriteShort(MSG_ONE, armor * DAMAGETEXT_PRECISION_MULTIPLIER);
            }
            if (!(flags & DTFLAG_NO_POTENTIAL))
            {
                if (flags & DTFLAG_BIG_POTENTIAL) WriteInt24_t(MSG_ONE, potential_damage * DAMAGETEXT_PRECISION_MULTIPLIER);
                else WriteShort(MSG_ONE, potential_damage * DAMAGETEXT_PRECISION_MULTIPLIER);
			}
        }
    ));
}