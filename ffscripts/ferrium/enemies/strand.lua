local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:StrandSackEffect(e)
    local d = mod:GetEntityData(e)
    local sprite = e:GetSprite()

    if not d.init then
        e.SplatColor = mod.ColorWebWhite
        d.State = "Appear"
        d.init = true
    else
    end

    if mod.IsActiveRoom() then
        if d.MyStrand then
            if not mod:superExists(d.MyStrand) then
                d.BreakStrand = true
            end
        end

        if d.State == "Appear" then
            if sprite:IsFinished("WebAppear") then
                d.State = "Idle"
            else
                mod:spritePlay(sprite, "WebAppear")
            end
        else
            mod:spritePlay(sprite, "WebIdle")
        end

        if d.OtherStrandEgg then
            if d.OtherStrandEgg:Exists() then
                for i = 1, game:GetNumPlayers() do
                    local player = Isaac.GetPlayer(i - 1)
                    if mod:IsPosInBetweenBad(e.Position, d.OtherStrandEgg.Position, player.Position, 10) then
                        mod:GetEntityData(d.OtherStrandEgg).BreakStrand = true
                        d.BreakStrand = true
                        sfx:Play(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, 1)
                    end
                end
            else
                d.BreakStrand = true
            end
        end

        e.Velocity = Vector.Zero

        if d.BreakStrand then
            local par = e
            if d.MyStrand and mod:superExists(d.MyStrand) then
                par = d.MyStrand
            end
            local testPath = Isaac.Spawn(mod.FF.ChummerPathfinder.ID, mod.FF.ChummerPathfinder.Var, 0, e.Position, Vector.Zero, nil):ToNPC()
            testPath.Visible = false
            testPath:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            testPath:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
            testPath.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            if testPath.Pathfinder:HasPathToPos(testPath:GetPlayerTarget().Position, false) then
                local rng = e:GetDropRNG()
                if rng:RandomInt(2) == 0 then
                    EntityNPC.ThrowSpider(e.Position, par, mod:chooserandomlocationforskuzz(testPath, 100, 50), false, -3)
                else
                    mod.ThrowSkuzz(e.Position, mod:chooserandomlocationforskuzz(testPath, 100, 50), par, -3)
                end
            end
            testPath:Remove()

            if d.StrandLine and d.StrandLine:Exists() then
                d.StrandLine:Remove()
            end
            local poof = Isaac.Spawn(1000, 2, 150, e.Position, Vector.Zero, e):ToEffect()
            poof.Color = e.SplatColor
            poof.SpriteScale = Vector(0.6, 0.6)
            poof.SpriteOffset = Vector(0, 5)
            poof:Update()
            e:Kill()
            e:Remove()
        end
    else
        if d.StrandLine and d.StrandLine:Exists() then
            d.StrandLine:Remove()
        end
        local poof = Isaac.Spawn(1000, 2, 150, e.Position, Vector.Zero, e):ToEffect()
        poof.Color = e.SplatColor
        poof.SpriteScale = Vector(0.6, 0.6)
        poof.SpriteOffset = Vector(0, 5)
        poof:Update()
        e:Kill()
        e:Remove()
    end
end