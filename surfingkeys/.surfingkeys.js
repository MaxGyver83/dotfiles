// These settings are optimized for the VOU keyboard layout:
// https://maximilian-schillinger.de/vou-layout.html

Hints.characters = 'caeiybtrnsoughzx,dwm';
settings.hintAlign = "right";

settings.blacklistPattern = /groups.google.com/i;
unmapAllExcept(['f', 'af', 'gf','q', 'i', 'H', 'S', 'D', 'E', 'R', 'e', 'd', ';e', '<Ctrl-6>', '?']);
//unmap('r'); // Ctrl-r / F5
//unmap('x'); // Ctrl-w

unmapAllExcept([], /urac.github.io\/Belegungstester/i);
unmapAllExcept(['f', 'q', 'i', ';e'], /mail\.google\.com/i);
unmapAllExcept(['f', 'q', 'i', ';e', 'T', '<Ctrl-6>'], /maximilian-schillinger\.de\/n\//i);
unmapAllExcept(['f', 'q', 'i', ';e', 'T', '<Ctrl-6>'], /http:\/\/127\.0\.0\.1:8080/i);
unmapAllExcept(['f', 'q', 'i', ';e', 'T', '<Ctrl-6>'], /localhost:8080/);
unmapAllExcept(['f', 'q', 'i', ';e', 'T', '<Ctrl-6>'], /\/Downloads\/Wiki\//);
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

// map('<Ctrl-.>', '<Ctrl-6>'); // go to last active tab

mapkey('p', '#0enter ephemeral PassThrough mode to temporarily suppress SurfingKeys', function() {
    Normal.passThrough(1500);
});


// set theme
settings.theme = `
.sk_theme {
    font-family: Input Sans Condensed, Charcoal, sans-serif;
    font-size: 10pt;
    background: #24272e;
    color: #abb2bf;
}
.sk_theme tbody {
    color: #fff;
}
.sk_theme input {
    color: #d0d0d0;
}
.sk_theme .url {
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchResult>ul>li:nth-child(odd) {
    background: #303030;
}
.sk_theme #sk_omnibarSearchResult>ul>li.focused {
    background: #3e4452;
}
#sk_status, #sk_find {
    font-size: 20pt;
}`;
// click `Save` button to make above settings to take effect.
