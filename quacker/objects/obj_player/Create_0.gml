// Player stats
hp = 100;
max_hp = 100;
attack_damage = 20;
move_speed = 4;
attack_cooldown = 0;
attack_cooldown_max = 20;
state = "idle";
facing_right = true; // For horizontal flipping only

// Jump variables
can_jump = true;
jump_speed = 2;
jump_height = 10;
jump_current = 0;
is_jumping = false;

// Initialize sprite
sprite_index = spr_duck_idle;
image_speed = 0.5;