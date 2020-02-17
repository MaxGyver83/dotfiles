// These settings are optimized for the KOU keyboard layout:
// https://maximilian-schillinger.de/kou-layout.html

Hints.characters = 'haeiybtrnsougczx,';

unmapAllExcept(['f', 'af', 'gf','q', 'i', '<Ctrl-i>', 'H', 't', 'S', 'D', 'e', 'd', 'se', '?']);
//unmap('r'); // Ctrl-r / F5
//unmap('x'); // Ctrl-w

unmapAllExcept(['f', 'q', 'i', '<Ctrl-i>', 'cs'], /mail\.google\.com/i);
unmapAllExcept(['f', 'q', 'i', '<Ctrl-i>', 'cs'], /maximilian-schillinger\.de\/notizen.html/i);
unmapAllExcept(['f', 'q', 'i', '<Ctrl-i>', 'cs', 'T'], /http:\/\/127\.0\.0\.1:8080/i);
//unmap('t', /http:\/\/127\.0\.0\.1:8080/i);

map('`', "'"); // use ` instead of '

vmap('temp', ',');
vmap(',', ';');
vmap(';', 'temp');
vunmap('temp');

map('temp', 'h'); // left
map('h', 'j');    // down
map('j', 'l');    // right
map('l', 'f');    // follow link
map('f', 'temp'); // left
unmap('temp');

map('al', 'af');
map('gl', 'gf');
map('cl', 'cf');

map(',', 'd'); // scroll down (up='e')

map('K', 'E'); // tab left
map('!', 'R'); // tab right
map('A', 'S'); // back in history
map('E', 'D'); // forward in history
