local mod = FiendFolio
local game = Game()

mod.CustomCursors = {
    Cursors = {},
    ANM2 = {
        DEFAULT     = "gfx/ui/cursors/default.anm2",
        CORNER 	    = "gfx/ui/cursors/corner.anm2",
        CORNER32    = "gfx/ui/cursors/corner32.anm2",
        PRONOUNCED  = "gfx/ui/cursors/pronounced.anm2",
        SWORD	    = "gfx/ui/cursors/flaming_sword.anm2",
        BANANA	    = "gfx/ui/cursors/potassium.anm2",
        EYE		    = "gfx/ui/cursors/zeros_eye.anm2",
        TRICKY	    = "gfx/ui/cursors/tricky_keys.anm2",
        SBURB	    = "gfx/ui/cursors/sburb.anm2",
        AWESOME	    = "gfx/ui/cursors/awesome.anm2",
        SATELLITE   = "gfx/ui/cursors/satellite.anm2",
        PLUMBER     = "gfx/ui/cursors/plumber.anm2",
        ORC         = "gfx/ui/cursors/orc.anm2",
        NEKO        = "gfx/ui/cursors/neko.anm2",
        GAUNTLET    = "gfx/ui/cursors/cursor_gauntlet.anm2",
    }
}

function mod.AddCursor(name, gfxpath, anm2)
	table.insert(mod.CustomCursors.Cursors, {
		string.lower(name),
		gfxpath,
		anm2 or mod.CustomCursors.ANM2.DEFAULT,
	})

	table.insert(FiendFolio.DSS_DIRECTORY.settingsCursor.buttons[1].choices, string.lower(name))
end

local function getCursorPath()
    if mod.DefaultCursorPath then
        return mod.DefaultCursorPath
    end

    --Default
    local path = "gfx/ui/cursor.png"
    --Juuuuuust in case someone changes it
    local sprite = Isaac.GetCursorSprite()
    local layer = sprite:GetLayer(0)
    if layer then
        path = layer:GetDefaultSpritesheetPath()
    end

    mod.DefaultCursorPath = path
    return path
end

--1px Crosshairs
mod.AddCursor("Default",		 getCursorPath(), "gfx/ui/cursor.anm2")
mod.AddCursor("Default Improved","gfx/ui/cursors/cursor_default.png")
mod.AddCursor("Diagonal",		 "gfx/ui/cursors/cursor_diagonal.png")
mod.AddCursor("Crosshair",		 "gfx/ui/cursors/cursor_crosshair.png")
mod.AddCursor("Satellite", 	     "gfx/ui/cursors/cursor_satellite.png", mod.CustomCursors.ANM2.SATELLITE)
--2px Crosshairs
mod.AddCursor("Wasteland King", "gfx/ui/cursors/cursor_wasteland.png")
mod.AddCursor("Dot", 			"gfx/ui/cursors/cursor_dot.png")
mod.AddCursor("Yung Venuz", 	"gfx/ui/cursors/cursor_yung.png")
--Cursors
mod.AddCursor("Cursor",			"gfx/ui/cursors/cursor_cursor.png", mod.CustomCursors.ANM2.CORNER)
mod.AddCursor("Pronounced", 	 "gfx/ui/cursors/cursor_pronounced.png", mod.CustomCursors.ANM2.PRONOUNCED)
mod.AddCursor("Point",			"gfx/ui/cursors/cursor_tricky_keys.png", mod.CustomCursors.ANM2.TRICKY)
mod.AddCursor("Relogical", 	    "gfx/ui/cursors/cursor_relogical.png", mod.CustomCursors.ANM2.CORNER)
--Cursors with guys
mod.AddCursor("Isaac", 			"gfx/ui/cursors/cursor_isaac.png", mod.CustomCursors.ANM2.CORNER)
mod.AddCursor("Miku", 			"gfx/ui/cursors/cursor_miku.png", mod.CustomCursors.ANM2.CORNER)
mod.AddCursor("Dolphin", 		"gfx/ui/cursors/cursor_dolphin.png", mod.CustomCursors.ANM2.CORNER)
mod.AddCursor("Original Starwalker", 	"gfx/ui/cursors/cursor_starwalker.png", mod.CustomCursors.ANM2.CORNER)
mod.AddCursor("Madness Combat Grunt", 	"gfx/ui/cursors/cursor_grunt.png", mod.CustomCursors.ANM2.CORNER)
--mod.AddCursor("Relogical", 	"gfx/ui/cursors/cursor_relogical.png", mod.CustomCursors.ANM2.CORNER)
mod.AddCursor("Plumber", 	"gfx/ui/cursors/cursor_plumber.png", mod.CustomCursors.ANM2.PLUMBER)
mod.AddCursor("Orc", 	"gfx/ui/cursors/cursor_orc.png", mod.CustomCursors.ANM2.ORC)

mod.AddCursor("Potassium", "gfx/ui/cursors/cursor_potassium.png", mod.CustomCursors.ANM2.BANANA)
mod.AddCursor("Zero's Eye", "gfx/ui/cursors/cursor_zeros_eye.png", mod.CustomCursors.ANM2.EYE)
mod.AddCursor("Sword", "gfx/ui/cursors/cursor_flaming_sword.png", mod.CustomCursors.ANM2.SWORD)
mod.AddCursor("Pizza", "gfx/ui/cursors/cursor_pizza.png", mod.CustomCursors.ANM2.CORNER32)
mod.AddCursor("Sburb", "gfx/ui/cursors/cursor_sburb.png", mod.CustomCursors.ANM2.SBURB)
mod.AddCursor("Neko", "gfx/ui/cursors/cursor_neko.png", mod.CustomCursors.ANM2.NEKO)
mod.AddCursor("Peat", "gfx/ui/cursors/cursor_peat.png", mod.CustomCursors.ANM2.CORNER32)
mod.AddCursor("Awesome", "gfx/ui/cursors/cursor_awesome.png", mod.CustomCursors.ANM2.AWESOME)

--I don't want to mess with anyone's settings, we doin' this spindown style now
mod.AddCursor("Gauntlet", "gfx/ui/cursors/cursor_gauntlet.png", mod.CustomCursors.ANM2.GAUNTLET)

local varToScale = {
    [1] = 0.5,
    [2] = 1,
    [3] = 2,
}

function mod:UpdateCursorVisuals(forceCursor)
    local cursorSprite = Isaac.GetCursorSprite()
    local cursor = forceCursor or mod.CustomCursors.Cursors[mod.CursorOptionsVisual]

    cursorSprite:Load(cursor[3], true)

    cursorSprite:ReplaceSpritesheet(0, cursor[2])
    cursorSprite:LoadGraphics()

    local scale = varToScale[FiendFolio.CursorOptionsScale]
    cursorSprite.Scale = Vector(scale,scale)

    mod.CurrentCursor = cursor
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if mod.CursorOptionsVisual and mod.CursorOptionsVisual > 1 then
        local sprite = Isaac.GetCursorSprite()
        local playingAnim = sprite:GetAnimation()
        local anim = sprite:GetAnimationData(playingAnim)
        if anim then
            local name, frameLength = anim:GetName(), anim:GetLength()
            local frame = sprite:GetFrame()
            sprite:SetFrame(game:GetFrameCount() % frameLength)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	if mod.CursorOptionsRandomizer then
        mod.CursorOptionsVisual = math.random(#mod.CustomCursors.Cursors)
        mod:UpdateCursorVisuals()
    end
end)