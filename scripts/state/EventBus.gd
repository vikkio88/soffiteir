extends Node

signal target_hit(distance)
signal target_destroyed(is_headshot)
signal target_damaged(dmg, is_headshot)

signal player_mags_update(mags)
signal mag_update(type, bullets, starting_bullets)
signal weapon_switch(type)
