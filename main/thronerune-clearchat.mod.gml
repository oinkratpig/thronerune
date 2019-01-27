
global.someone_talked = false;
global.enabled = true;

boot_text();
wait(room_speed * 4);
if(global.enabled) boot_text();

#define chat_message
if(!global.someone_talked)
{
    global.someone_talked = true;
    clear();
}
global.enabled = false;

#define boot_text()
clear();
trace("THRONERUNE");
trace("  ");
trace("Various assets were created by the Nuclear Throne community.");
trace("Credit is given on the download page.");
trace("  ");
repeat(4) trace("  ");
trace("IT IS HIGHLY RECOMMENDED TO PLAY ON THE HIGHEST PIXEL MODE POSSIBLE!");
trace("IN NUCLEAR THRONE SETTINGS: Video > Pixel mode");
trace("  ");
trace("Enjoy the mod!");
trace("- Knilax");

#define clear()
repeat(19) trace("  ");