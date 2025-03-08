// get inputs
rightKey = keyboard_check(vk_right);
leftKey = keyboard_check(vk_left);
upKey = keyboard_check(vk_up);
downKey = keyboard_check(vk_down);

// get x and y speeds
xSpeed = (rightKey - leftKey) * moveSpeed;
ySpeed = (downKey - upKey) * moveSpeed;

// collisions
if place_meeting(x + xSpeed, y, oWall)
{
	xSpeed = 0;
}

if place_meeting(x, y + ySpeed, oWall)
{
	ySpeed = 0;
}

// move the player
x += xSpeed;
y += ySpeed;


