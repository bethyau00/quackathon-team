// --- Collision Event with obj_player (Alternative to hitbox approach) ---
/*
if (state != "dead" && other.hit_cooldown <= 0) {
    // Damage player on contact
    other.hp -= damage;
    other.hit_cooldown = 30;
    
    // Knockback
    var knock_dir = point_direction(x, y, other.x, other.y);
    with (other) {
        motion_add(knock_dir, 4);
    }
}
*/