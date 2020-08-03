// These settings are optimized for the VOU keyboard layout:
// https://maximilian-schillinger.de/vou-layout.html

Hints.characters = 'caeiybtrnsoughzx,dwm';
settings.hintAlign = "right";

settings.blacklistPattern = /groups.google.com/i;
unmapAllExcept(['f', 'af', 'gf','q', 'i', 'H', 't', 'S', 'D', 'E', 'R', 'e', 'd', ';e', '<Ctrl-6>', '?']);
//unmap('r'); // Ctrl-r / F5
//unmap('x'); // Ctrl-w

unmapAllExcept([], /urac.github.io\/Belegungstester/i);
unmapAllExcept(['f', 'q', 'i', ';e'], /mail\.google\.com/i);
unmapAllExcept(['f', 'q', 'i', ';e', 'T', '<Ctrl-6>'], /maximilian-schillinger\.de\/notizen.html/i);
unmapAllExcept(['f', 'q', 'i', ';e', 'T', '<Ctrl-6>'], /http:\/\/127\.0\.0\.1:8080/i);
//unmap('t', /http:\/\/127\.0\.0\.1:8080/i);

map('`', "'"); // use ` instead of '

vmap('temp', ',');
vmap(',', ';');
vmap(';', 'temp');
vunmap('temp');

// VOU, top right: L, H, F, J → follow link, left, right, down
map('temp', 'l'); // right
map('l', 'f');    // follow link
map('f', 'temp'); // right
unmap('temp');

map('al', 'af');
map('gl', 'gf');
map('cl', 'cf');

map(',', 'd'); // scroll down (up='e')

map('V', 'E'); // tab left
map('•', 'R'); // tab right
map('A', 'S'); // back in history
map('E', 'D'); // forward in history

map('<Ctrl-.>', '<Ctrl-6>'); // go to last active tab

mapkey('p', '#0enter ephemeral PassThrough mode to temporarily suppress SurfingKeys', function() {
    Normal.passThrough(1500);
});
