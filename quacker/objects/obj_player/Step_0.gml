// Handle movement
var move_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var move_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// Set state to idle by default if not in special states
if state != "attacking" && !is_jumping {
    state = "idle";
}

// Handle jumping with spacebar
if keyboard_check_pressed(vk_space) && can_jump && !is_jumping {
    is_jumping = true;
    can_jump = false;
    jump_current = 0;
    alarm[1] = 30; // Jump cooldown (1/2 second at 60fps)
}

// Process jumping
if is_jumping {
    jump_current += 1;
    
    // Move up during first half of jump
    if jump_current < jump_height {
        y -= jump_speed * (1 - (jump_current / jump_height)); // Gradually slow down
    } 
    // Move down during second half
    else if jump_current < jump_height * 2 {
        y += jump_speed * ((jump_current - jump_height) / jump_height); // Gradually speed up
    } 
    // End jump
    else {
        is_jumping = false;
    }
}

// Process movement
if move_x != 0 || move_y != 0 {
    // Normalize diagonal movement (safely)
    var move_len = sqrt(move_x * move_x + move_y * move_y);
    if move_len > 0 { // Prevent division by zero
        move_x = move_x / move_len * move_speed;
        move_y = move_y / move_len * move_speed;
    }
    
    // Update facing direction based on horizontal movement
    if move_x != 0 {
        facing_right = (move_x > 0);
    }
    
    // Change state to walking if not attacking and not jumping
    if state != "attacking" && !is_jumping {
        state = "walking";
        // Force sprite update immediately for walking
        sprite_index = spr_duck_walk;
    }
}

// Apply movement if not attacking (but allow horizontal movement while jumping)
if state != "attacking" {
    x += move_x;
    if !is_jumping {
        y += move_y;
    }
}

// Handle attack cooldown
if attack_cooldown > 0 {
    attack_cooldown--;
}

// Handle attack input
if mouse_check_button_pressed(mb_left) && attack_cooldown <= 0 {
    state = "attacking";
    attack_cooldown = attack_cooldown_max;
    alarm[0] = 15; // Duration of attack animation
    
    // Force sprite update immediately for attack
    sprite_index = spr_duck_attack;
    
    // Update facing direction based on mouse position
    facing_right = (mouse_x > x);
    
    // Check for enemies in attack range
    var attack_range = 50;
    var attack_x = x + (facing_right ? attack_range/2 : -attack_range/2);
    var enemy = collision_circle(attack_x, y, attack_range/2, obj_enemy, false, true);
    
    if enemy != noone {
        // Deal damage
        with(enemy) {
            hp -= other.attack_damage;
            // Knockback
            var dir = point_direction(other.x, other.y, x, y);
            x += lengthdir_x(15, dir); // Increased knockback
            y += lengthdir_y(15, dir);
        }
    }
}

// Prevent overlapping with enemies
var enemy = instance_nearest(x, y, obj_enemy);
if enemy != noone {
    var dist = point_distance(x, y, enemy.x, enemy.y);
    if dist < 30 { // Minimum distance to maintain
        var dir = point_direction(enemy.x, enemy.y, x, y);
        x += lengthdir_x(1, dir); // Slow push away
        y += lengthdir_y(1, dir);
    }
}

// Update sprite based on state (with fallback)
if state == "idle" {
    sprite_index = spr_duck_idle;
} else if state == "walking" {
    // Double-check if walk sprite exists, otherwise use idle
    if !sprite_exists(spr_duck_walk) {
        // Try using the sprite name directly in case of resource naming issues
        sprite_index = asset_get_index("spr_duck_walk");
        
        // If that fails, fall back to idle sprite
        if sprite_index == -1 {
            sprite_index = spr_duck_idle;
            // Show debug message
            show_debug_message("Warning: spr_duck_walk not found, using idle sprite");
        }
    } else {
        sprite_index = spr_duck_walk;
    }
} else if state == "attacking" {
    sprite_index = spr_duck_attack;
}

// Handle horizontal flipping only
image_xscale = facing_right ? 1 : -1;

// Check if player is defeated
if hp <= 0 {
    // Game over logic could go here
    show_message("Game Over!");
    game_restart();
}