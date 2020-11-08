#!/usr/bin/env python3

import iterm2
import os

async def main(connection):
    app = await iterm2.async_get_app(connection)

    @iterm2.RPC
    async def launch_alacritty():
        os.system('open /Applications/Alacritty.app')
    await launch_alacritty.async_register(connection)

iterm2.run_forever(main)
