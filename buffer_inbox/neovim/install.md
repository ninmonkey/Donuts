# Top
discord history about neovim  LSP 

> [!NOTE]
> thread starts at: https://discord.com/channels/180528040881815552/180528040881815552/1527701244066529320


**linked below**

- [TheLeoP/powershell.vim](https://github.com/TheLeoP/powershell.nvim)
  - contains [`nvim-dap` config](https://github.com/TheLeoP/powershell.nvim#dap)
- [matt dotfiles chezmoi: nvim/init](https://github.com/mattcargile/dotfiles/blob/93bbd240a36f8523cce0cb9c698cb8a0dd35f503/.chezmoitemplates/nvim/init.lua#L555-L602)


## Thread `␂`


**Matt Cargile [PWSH]**  — 2026-07-17 10:39 AM

So I got all of https://github.com/TheLeoP/powershell.nvim working and it appears to be really nice. Trying to figure out how to make :Powershell command work . Just seeing if anyone had maybe got it working before i submit an issue to the repo asking.
the debug UI and such is so nice in the neovim context.

**Matt Cargile [PWSH]**  — 2026-07-17 10:51 AM

I'm bascially trying to use powerShell/invokeExtensionCommand
Manbearpiet [PWSH],  — 2026-07-17 11:15 AM
Is that like DAP integration ?
 [PWSH], 

**Matt Cargile [PWSH]**  — 2026-07-17 11:23 AM

it does it all and more. the only thing I can't get working is the features of EditorServicesCommandSuite module 
debug term, pses term, eval the line, lsp, dap.
It would be nice to be able to hook into that Register-EditorCommand feature in nvim but it might just be a vscode thing
i just made https://github.com/TheLeoP/powershell.nvim/issues/9
Manbearpiet [PWSH],  — 2026-07-17 11:34 AM
Oh I've never used that haha 😄
I couldn't get it to work properly
I have the debug in here https://github.com/Manbearpiet/kickstart.nvim/blob/master/lua/kickstart/plugins/debug.lua#L27C5-L41C5
GitHub
kickstart.nvim/lua/kickstart/plugins/debug.lua at master · Manbear...
A launch point for your personal nvim configuration - Manbearpiet/kickstart.nvim
kickstart.nvim/lua/kickstart/plugins/debug.lua at master · Manbear...

**Matt Cargile [PWSH]**  — 2026-07-17 11:39 AM

hehe! i couldn't get nvim-dap-powershell to work
i'm on vim.pack iteration of kickstart
i get all twisted up with mason, nvim-lspconfig, mason-lspconfig, etc, etc
Manbearpiet [PWSH],  — 2026-07-17 11:40 AM
Yeah that's a hassle  😄

**Matt Cargile [PWSH]**  — 2026-07-17 11:40 AM

mason-tools-installer. it has been hours sunk
Manbearpiet [PWSH],  — 2026-07-17 11:40 AM
I have a branch with vim pack
Ah never pushed it

**Matt Cargile [PWSH]**  — 2026-07-17 11:41 AM

the "trick" with powershell.nvim was to require('powershell').setup after the debug.lua config 
and make sure mason-lspconfig wasn't double enabling powershell_es
i see you have stripped your init.lua way back! 
Manbearpiet [PWSH],  — 2026-07-17 11:42 AM
I always have a second powershell_es with the plugin

**Matt Cargile [PWSH]**  — 2026-07-17 11:42 AM

shouldn't have to
Manbearpiet [PWSH],  — 2026-07-17 11:43 AM
But without the plugin it works fine haha

**Matt Cargile [PWSH]**  — 2026-07-17 11:43 AM

yeah powershell.nvim does it all
Manbearpiet [PWSH],  — 2026-07-17 11:43 AM
With the dap setup
Image
But I use another session to debug anyway 😄

**Matt Cargile [PWSH]**  — 2026-07-17 11:43 AM

yeah powershell.nvim spawns a separate debug term session
it uses a single session for lsp and for the terminal stdio
hmm. not sure why it wouldn't work, i don't see nvim-lspconfig nor mason-lspconfig
Manbearpiet [PWSH],  — 2026-07-17 11:46 AM
But is mason-lspconfig still needed at 0.12 ?

**Matt Cargile [PWSH]**  — 2026-07-17 11:47 AM

it is needed for my mason-tools-installer to translate the mason registry name to the nvim-lspconfig
Manbearpiet [PWSH],  — 2026-07-17 11:47 AM
Isn't the LSP autostarted and autoattached? 😄

**Matt Cargile [PWSH]**  — 2026-07-17 11:47 AM

like mason calls it powershell-editor-services and nvim-lspconfig calls it powershell_es
mason-lspconfig does a translation
Manbearpiet [PWSH],  — 2026-07-17 11:48 AM
Ah yeah

**Matt Cargile [PWSH]**  — 2026-07-17 11:48 AM

but you got it all done by hand
Manbearpiet [PWSH],  — 2026-07-17 11:48 AM
I don't install the LSP's with Mason

**Matt Cargile [PWSH]**  — 2026-07-17 11:48 AM

which i would consider down the line to force less plugins
Manbearpiet [PWSH],  — 2026-07-17 11:49 AM
Had some fights with it in June last year
I really need to do a summer sweep of the plugins I don't use half of them

**Matt Cargile [PWSH]**  — 2026-07-17 11:49 AM

yeah i'm waffling over telescope vs fzf-lua vs mini-pick
telescope appears to be mostly unmaintained 
Manbearpiet [PWSH],  — 2026-07-17 11:50 AM
Telescope is fine to me 😄, but I am curious how you fare haha 

**Matt Cargile [PWSH]**  — 2026-07-17 11:50 AM

yeah it has been good for me mostly
Manbearpiet [PWSH],  — 2026-07-17 11:51 AM
If I can drop kickstart haha 

**Matt Cargile [PWSH]**  — 2026-07-17 11:51 AM

the neovim maintainers implicitly reccomend fzf-lua in their example config 
like neovim itself https://github.com/neovim/neovim/blob/master/runtime/example_init.lua
even kickstart is kind of falling over with the weight of its success, etc
it is somewhat simpler now without the lazy package manager
Manbearpiet [PWSH],  — 2026-07-17 11:55 AM
Is it still fast 😛 ?
I detest the microsoft defender setup on my m1 macbook from work. The work m1 half as slow as my private M1.
So navigation already feels slow, which initially motivated me to go nvim. 

**Matt Cargile [PWSH]**  — 2026-07-17 11:58 AM

well, i got into nvim at 0.12 so i missed the lazy saga. i think it is fast. i saw someone with a benchmark and the lost of speed was under 10 ms. especially with 
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()
Manbearpiet [PWSH],  — 2026-07-17 11:59 AM
It's silly, I have a Ubuntu work setup too without defender and it's blazing fast. 

**Matt Cargile [PWSH]**  — 2026-07-17 11:59 AM

and yeah vscode just got way too slow.
msmpeng.exe kills perf so bad i had to disable it on my personal. forget about it on my employer machine. sentinel one, arctic wolf, sysmon. it drags!
with nvim, it is like a dream
so many wow moments that is makes up for all the growing pains learning
telescope alone blew my mind plus go to definition, crazy 
i'd been living in the stone ages clicking around in sql server management studio manually scripting out the views and objects.
the diagnositic work flow, the debug, it is just incredible
Manbearpiet [PWSH],  — 2026-07-17 12:01 PM
Go to Definition only works within a file for me

**Matt Cargile [PWSH]**  — 2026-07-17 12:01 PM

it worked great with mssql with sqltoolsservice
now with ps1, it could probably be worked with to force decompilation of dll and finding the module file, etc
Manbearpiet [PWSH],  — 2026-07-17 12:04 PM
I'm not sure if EditorServices supports it, right?

**Matt Cargile [PWSH]**  — 2026-07-17 12:04 PM

yeah i was gonna say, not sure how good go to def is in vscode
i never really used it but in nvim, it is at my fingertips
so in the dbatools repo, i can be inside a function and it will jump across folders to go to another file.
now i doubt it will be able to jump outside the project to transient dependencies or hard compiled dependencies without extra help
Manbearpiet [PWSH],  — 2026-07-17 12:08 PM
I remember asking mr seeminglyscience once in discord, but not it was something something vscode heuristics if I remember correctly 

**Matt Cargile [PWSH]**  — 2026-07-17 12:09 PM

yeah he would know. i have my go to def going through telescope so i really don't know how it is working.
https://github.com/mattcargile/dotfiles/blob/93bbd240a36f8523cce0cb9c698cb8a0dd35f503/.chezmoitemplates/nvim/init.lua#L555-L602
i guess it hooks into vim.lsp and if more than one will give me a picker. i'd have to figure out how to rip that out maybe. another day...
it is amazing with mssql though

**Matt Cargile [PWSH]**  — 2026-07-17 12:21 PM

having treesitter parse both ps1 inside the golang tmpl was pretty mind blowing too
nested syntax highlighting was really cool to see working
Manbearpiet [PWSH],  — 2026-07-17 12:33 PM

## Thread `␃`

[Top](#top)